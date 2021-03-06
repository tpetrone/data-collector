# frozen_string_literal: true

# Create and update platform resources. After store data, create a new worker
# to collect data from resource-adaptor.
class PlatformResourcesController < ApplicationController
  skip_before_action :verify_authenticity_token
  before_action :find_platform_resource, only: [:update]

  def create
    platform_resource = PlatformResource.new(platform_resource_params)
    platform_resource.save!
    assotiate_capability_with_resource(param_capabilities, platform_resource)
    render json: { data: platform_resource }, status: 201
  rescue ActiveRecord::RecordNotUnique => err
    LOGGER.error("Error when tried to create resource. #{err}")
    render json: { error: 'Duplicated uuid' }, status: 400
  rescue
    LOGGER.error("Attempt to store resource: #{platform_resource.inspect}")
    render json: { error: 'Internal Server Error' }, status: 500
  end

  def update
    raise ActiveRecord::RecordNotFound unless @retrieved_resource
    @retrieved_resource.update!(platform_resource_params)

    capabilities = param_capabilities
    remove_needed_capabilities(capabilities, @retrieved_resource)

    assotiate_capability_with_resource(capabilities, @retrieved_resource)

    render json: { data: @retrieved_resource }, status: 201

  rescue ActiveRecord::RecordNotFound => err
    LOGGER.info("Error when tried to update resource. #{err}")
    render json: { error: 'Not found' }, status: 404
  end

  private

  def platform_resource_params
    params.require(:data).permit(:uri, :uuid, :status, :collect_interval)
  end

  def capability_params
    params.require(:data).permit(capabilities: [])
  end

  def find_platform_resource
    @retrieved_resource = PlatformResource.find_by_uuid(params[:uuid])
  end

  def param_capabilities
    capability_params[:capabilities]
  end

  def assotiate_capability_with_resource(capabilities, resource)
    if capabilities.kind_of? Array
      capabilities.each do |capability_name|
        # Thread safe
        begin
          capability = Capability.find_or_create_by(name: capability_name)
        rescue ActiveRecord::RecordNotUnique => err
          LOGGER.info("Attempt to create duplicated capability. #{err}")
          capability = Capability.find_by_name(capability_name)
        end
        unless resource.capabilities.include?(capability)
          resource.capabilities << capability
        end
      end
    end
  end

  def remove_needed_capabilities(capabilities, resource)
    # If no capabilities are present inside hash, just remove all
    if capabilities.nil?
      resource.capabilities.delete_all
    else
      rm = resource.capabilities.where('name not in (?)', capabilities)
      resource.capabilities.delete(rm)
    end
  end
end
