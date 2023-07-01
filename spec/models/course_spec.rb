require 'rails_helper'

RSpec.describe Course, type: :model do
  describe "associations" do

    context "has_and_belongs_to_many" do
      it "students" do
        association = Course.reflect_on_association(:students).macro
        expect(association).to be(:has_and_belongs_to_many)
      end
    end

    context "has_many" do
      [:topics,:tests].each do |each|
        it each.to_s.humanize do
          association = Course.reflect_on_association(each).macro
          expect(association).to be(:has_many)
        end
      end
    end

    context "belongs_to" do
      let(:instructor) {create(:instructor)}
      let(:course) {create(:course,instructor:instructor)}
      it "instructor is true" do
        expect(course.instructor).to be_an_instance_of(Instructor)
      end
    end

  end

  describe "name" do
    before(:each) do
      course.validate
    end

    context "when name is empty" do
      let!(:course) {build(:course, name:"")}
      it "throws an error" do
        expect(course.errors).to include(:name)
      end
    end

    context "when name is not present" do
      let!(:course) {build(:course, name:nil)}
      it "throws an error" do
        expect(course.errors).to include(:name)
      end
    end

    context "when name length is less than 3" do
      let!(:course) {build(:course, name:"DS")}
      it "throws an error" do
        expect(course.errors).to include(:name)
      end  
    end

    context "when name length is greater than 20" do
      let!(:course) {build(:course, name:"Data Structures and Algorithms")}
      it "throws an error" do
        expect(course.errors).to include(:name)
      end 
    end

    context "when name is present" do
      let!(:course) {build(:course, name: "Linear Search")}
      it "doesn't throw any error" do
        expect(course.errors).to_not include(:name)
      end
    end
  end


  describe "category" do
    before(:each) do
      course.validate
    end

    context "when category is empty" do
      let!(:course) {build(:course, category:"")}
      it "throws an error" do
        expect(course.errors).to include(:category)
      end
    end

    context "when category is not present" do
      let!(:course) {build(:course, category:nil)}
      it "throws an error" do
        expect(course.errors).to include(:category)
      end
    end

    context "when category length is less than 3" do
      let!(:course) {build(:course, category:"DS")}
      it "throws an error" do
        expect(course.errors).to include(:category)
      end  
    end

    context "when category length is greater than 50" do
      let!(:course) {build(:course, category:"Lorem Ipsum, sometimes referred to as 'lipsum', is the placeholder text used in design when creating content. It helps designers plan out where the content will sit, without needing to wait for the content to be written and approved.")}
      it "throws an error" do
        expect(course.errors).to include(:category)
      end 
    end

    context "when category is present" do
      let!(:course) {build(:course, category: "Data Structures and Algorithms")}
      it "doesn't throw any error" do
        expect(course.errors).to_not include(:category)
      end
    end
  end

end
