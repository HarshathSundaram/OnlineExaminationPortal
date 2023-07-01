require 'rails_helper'

RSpec.describe Test, type: :model do
  describe "associations" do
    context "belongs_to" do
      let!(:test) {create(:test, :for_course)}
      it "course is true" do
        expect(test.testable).to be_an_instance_of(Course)
      end
    end
    context "belongs_to" do
      let!(:test) {create(:test, :for_topic)}
      it "instructor is true" do
        expect(test.testable).to be_an_instance_of(Topic)
      end
    end

    context "has_many" do
      it "Test Histories" do
        association = Test.reflect_on_association(:test_histories).macro
        expect(association).to be(:has_many)
      end
    end

  end

  describe "name" do
    before(:each) do
      test.validate
    end

    context "when name is empty" do
      let!(:test) {build(:test, name:"")}
      it "throws an error" do
        expect(test.errors).to include(:name)
      end
    end

    context "when name is not present" do
      let!(:test) {build(:test, name:nil)}
      it "throws an error" do
        expect(test.errors).to include(:name)
      end
    end

    context "when name length is less than 2" do
      let(:test) {build(:test, name:"DS")}
      it "throws an error" do
        expect(test.errors).to include(:name)
      end  
    end

    context "when name length is greater than 20" do
      let!(:test) {build(:test, name:"Data Structures and Algorithms")}
      it "throws an error" do
        expect(test.errors).to include(:name)
      end 
    end

    context "when name is present" do
      let!(:test) {build(:test, name: "Linear Search")}
      it "doesn't throw any error" do
        expect(test.errors).to_not include(:name)
      end
    end
  end

  describe "questions" do
    before(:each) do
      test.validate
    end
    context "when question is not present" do
      let!(:test) {build(:test,questions:nil)}
      it "throws an error" do
        expect(test.errors[:questions]).to include("Please add questions")
      end
    end
    
    context "when question is empty" do
      let!(:test) {build(:test,questions:"")}
      it "throws an error" do
        expect(test.errors[:questions]).to include("must be an array")
      end
    end

    context "when question is not a json format" do
      let(:test) {build(:test,questions:["Welcome"])}
      it "throws an error" do
        expect(test.errors).to include(:questions)
      end
    end

    context "when question is not present" do
      let(:test) {build(:test,questions:[{options:{"0":"Hell0"},answer:"2",mark:"1"}])}
      it "throws an error" do
        expect(test.errors[:questions]).to include("has an invalid format for question 0")
      end
    end

    context "when option is not present" do
      let(:test) {build(:test,questions:[{question:"1?",answer:"2",mark:"1"}])}
      it "throws an error" do
        expect(test.errors[:questions]).to include("has an invalid format for question 0")
      end
    end

    context "when answer is not present" do
      let(:test) {build(:test,questions:[{question:"1?",options:{"0":"Hell0"},mark:"1"}])}
      it "throws an error" do
        expect(test.errors[:questions]).to include("has an invalid format for question 0")
      end
    end

    context "when mark is not present" do
      let(:test) {build(:test,questions:[{question:"1?", options:{"0":"Hell0"},answer:"2"}])}
      it "throws an error" do
        expect(test.errors[:questions]).to include("has an invalid format for question 0")
      end
    end

    context "when question,option,mark, and answer are present" do
      let(:test) {build(:test,questions:[{question:"1?", options:{"0":"Hell0"},answer:"2",mark:"2"}])}
      it "doesn't throw an error" do
        expect(test.errors).to_not include(:questions)
      end
    end

  end
end
