require 'rails_helper'

RSpec.describe Topic, type: :model do
  describe "associations" do
    
    context "has_many" do
      it "tests" do
        association = Topic.reflect_on_association(:tests).macro
        expect(association).to be(:has_many)
      end
    end

    context "belongs_to" do
      let(:course) {create(:course)}
      let(:topic) {create(:topic,course:course)}
      it "course is true" do
        expect(topic.course).to be_an_instance_of(Course)
      end
    end

  end

  describe "name" do
    before(:each) do
      topic.validate
    end

    context "when name is empty" do
      let!(:topic) {build(:topic, name:"")}
      it "throws an error" do
        expect(topic.errors).to include(:name)
      end
    end

    context "when name is not present" do
      let!(:topic) {build(:topic, name:nil)}
      it "throws an error" do
        expect(topic.errors).to include(:name)
      end
    end

    context "when name length is less than 3" do
      let!(:topic) {build(:topic, name:"DS")}
      it "throws an error" do
        expect(topic.errors).to include(:name)
      end  
    end

    context "when name length is greater than 20" do
      let!(:topic) {build(:course, name:"Data Structures and Algorithms")}
      it "throws an error" do
        expect(topic.errors).to include(:name)
      end 
    end

    context "when name is present" do
      let!(:topic) {build(:topic, name: "Linear Search")}
      it "doesn't throw any error" do
        expect(topic.errors).to_not include(:name)
      end
    end
  end

  describe "description" do
    before(:each) do
      topic.validate
    end

    context "when description is empty" do
      let!(:topic) {build(:topic, description:"")}
      it "throws an error" do
        expect(topic.errors).to include(:description)
      end
    end

    context "when description is not present" do
      let!(:topic) {build(:topic, description:nil)}
      it "throws an error" do
        expect(topic.errors).to include(:description)
      end
    end

    context "when description length is less than 10" do
      let!(:topic) {build(:topic, description:"DS")}
      it "throws an error" do
        expect(topic.errors).to include(:description)
      end  
    end

    context "when description length is greater than 150" do
      let!(:topic) {build(:topic, description:"Lorem Ipsum, sometimes referred to as 'lipsum', is the placeholder text used in design when creating content. It helps designers plan out where the content will sit, without needing to wait for the content to be written and approved.")}
      it "throws an error" do
        expect(topic.errors).to include(:description)
      end 
    end

    context "when description is present" do
      let!(:topic) {build(:topic, description: "Data Structures and Algorithms")}
      it "doesn't throw any error" do
        expect(topic.errors).to_not include(:description)
      end
    end
  end


end
