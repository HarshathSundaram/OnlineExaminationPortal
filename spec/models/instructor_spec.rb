require 'rails_helper'

RSpec.describe Instructor, type: :model do
  describe "associations" do

    context "has_many" do
      it "Courses" do
        association = Instructor.reflect_on_association(:courses).macro
        expect(association).to be(:has_many)
      end
    end

    context "has_one" do
      it "User" do
        association = Instructor.reflect_on_association(:user).macro
        expect(association).to be(:has_one)
      end
    end

  end

  describe "designation" do
    before(:each) do
      instructor.validate
    end

     context "when designation is not present" do
      let(:instructor) {build(:instructor,designation:nil)}
      it "throws an error" do
        expect(instructor.errors).to include(:designation)
      end
     end

     context "when designation is empty" do
      let(:instructor) {build(:instructor,designation:"")}
      it "throws an error" do
        expect(instructor.errors).to include(:designation)
      end
     end

     context "when designation is present" do
      let(:instructor) {build(:instructor,designation:"professor")}
      it "doesn't throw any error" do
        expect(instructor.errors).to_not include(:designation)
      end
     end

  end

  describe "callbacks" do
    context "designation is upcase" do
      let(:instructor) {build(:instructor)}
      before do
        instructor.save
      end
      it "is upcase" do
        expect(instructor.designation).to eq(instructor.designation.upcase)
      end
    end
 end

end
