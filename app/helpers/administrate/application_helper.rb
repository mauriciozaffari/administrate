module Administrate
  module ApplicationHelper
    PLURAL_COUNT = 2.1

    def render_field(field, locals = {})
      locals.merge!(field: field)
      render locals: locals, partial: field.to_partial_path
    end

    def class_from_resource(resource_name)
      resource_name.to_s.split("__").map(&:classify).join("::").constantize
    end

    def display_resource_name(resource_name, count: PLURAL_COUNT, default: nil)
      default ||= begin
        s = resource_name.to_s.singularize
        s = s.pluralize unless count == 1
        s.titleize.squish
      end

      class_from_resource(resource_name).
        model_name.
        human(
          count: count,
          default: default,
        )
    end

    def sort_order(order)
      case order
      when "asc" then "ascending"
      when "desc" then "descending"
      else "none"
      end
    end

    def resource_index_route_key(resource_name)
      ActiveModel::Naming.route_key(class_from_resource(resource_name))
    end

    def sanitized_order_params(page, current_field_name)
      collection_names = page.association_includes + [current_field_name]
      association_params = collection_names.map do |assoc_name|
        { assoc_name => %i[order direction page per_page] }
      end
      params.permit(:search, :id, :page, :per_page, association_params)
    end

    def clear_search_params
      params.except(:search, :page).permit(
        :per_page, resource_name => %i[order direction]
      )
    end
  end
end
