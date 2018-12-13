require "rails_helper"

RSpec.describe Administrate::ApplicationHelper do
  describe "#display_resource_name" do
    it "defaults to the plural of the model name" do
      displayed = display_resource_name(:customer)

      expect(displayed).to eq("Customers")
    end

    it "shows the singular of the model name" do
      displayed = display_resource_name(:customer, count: 1)

      expect(displayed).to eq("Customer")
    end

    it "shows a default string when supplied" do
      displayed = display_resource_name(:customer, default: "Special Customer")

      expect(displayed).to eq("Special Customer")
    end

    it "handles string arguments" do
      displayed = display_resource_name("customer")

      expect(displayed).to eq("Customers")
    end

    it "handles plural arguments" do
      displayed = display_resource_name(:customers)

      expect(displayed).to eq("Customers")
    end

    context "when translations are defined" do
      before do
        @translations = {
          activerecord: {
            models: {
              customer: {
                one: "User",
                other: "Users",
              },
            },
          },
        }
      end

      it "uses the plural of the defined translation" do
        with_translations(:en, @translations) do
          displayed = display_resource_name(:customer)

          expect(displayed).to eq("Users")
        end
      end

      it "uses the singular of the defined translation when count is 1" do
        with_translations(:en, @translations) do
          displayed = display_resource_name(:customer, count: 1)

          expect(displayed).to eq("User")
        end
      end

      it "ignores the default string" do
        with_translations(:en, @translations) do
          displayed = display_resource_name(:customer, default: "Ignored")

          expect(displayed).to eq("Users")
        end
      end
    end
  end

  describe "#resource_index_route_key" do
    it "handles index routes when resource is uncountable" do
      route_key = resource_index_route_key(:series)
      expect(route_key).to eq("series_index")
    end

    it "handles normal inflection" do
      route_key = resource_index_route_key(:customer)
      expect(route_key).to eq("customers")
    end
  end

  describe "#sort_order" do
    it "sanitizes to ascending/descending/none" do
      expect(sort_order("asc")).to eq("ascending")
      expect(sort_order("desc")).to eq("descending")
      expect(sort_order("for anything else")).to eq("none")
    end
  end
end
