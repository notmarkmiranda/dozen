shared_examples "settable" do
  it { should have_many(:settings) }
end