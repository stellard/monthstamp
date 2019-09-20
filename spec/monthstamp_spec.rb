require 'spec_helper'
require 'shared_examples'

RSpec.describe Monthstamp do
  it "has a version number" do
    expect(Monthstamp::VERSION).not_to be nil
  end

  describe "Date" do
    subject { Date }
    include_examples "monthstamp"
  end

  describe "Time" do
    subject { Time }
    include_examples "monthstamp"
  end

  describe "DateTime" do
    subject { DateTime }
    include_examples "monthstamp"
  end

end
