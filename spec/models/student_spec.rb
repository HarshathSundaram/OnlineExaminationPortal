require 'rails_helper'

RSpec.describe Student, type: :model do

  describe "associations" do
    
    context "has_many" do
      
      [:test_histories,:tests].each do |each|
        
        it each.to_s.humanize do
          association = Student.reflect_on_association(each).macro
          expect(association).to be(:has_many)
        end
      
      end
    
    end

    context "has_and_belongs_to_many" do
       it "courses" do
          association = Student.reflect_on_association(:courses).macro
          expect(association).to be(:has_and_belongs_to_many)
       end
    end

    context "has_one" do 
      [:latest_test_history,:latest_test,:user].each do |each|
        it each.to_s.humanize do
          association = Student.reflect_on_association(each).macro
          expect(association).to be(:has_one)
        end
      end
    end

  end

  describe "department" do
    before(:each) do
      student.validate
    end


    context "when department is not present" do
      let(:student) {build(:student,department:nil)}
      it "throws an error" do
        expect(student.errors).to include(:department)
      end
    end

    context "when department is empty" do
      let(:student) {build(:student,department:"")}
      it "throws an error" do
        expect(student.errors).to include(:department)
      end
    end

    context "when department is present" do
      let(:student) {build(:student, department:"IT")}
      it "doesn't throw any error" do
        expect(student.errors).to_not include(:department)
      end
    end


  end

  describe "year" do
    before(:each) do
      student.validate
    end


    context "when year is not present" do
      let(:student) {build(:student,year:nil)}
      it "throws an error" do
        expect(student.errors).to include(:year)
      end
    end

    context "when year is empty" do
      let(:student) {build(:student,year:"")}
      it "throws an error" do
        expect(student.errors).to include(:year)
      end
    end

    context "when year is present" do
      let(:student) {build(:student, department:"1")}
      it "doesn't throw any error" do
        expect(student.errors).to_not include(:year)
      end
    end


  end

  describe "callbacks" do
    context "department is upcase" do
      let(:student) {build(:student)}
      before do
        student.save
      end
      it "is upcase" do
        expect(student.department).to eq(student.department.upcase)
      end
    end
 end


end
