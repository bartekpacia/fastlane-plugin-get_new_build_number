describe Fastlane::Actions::GetNewBuildNumberAction do
  describe '#run' do
    it 'prints a message' do
      expect(Fastlane::UI).to receive(:message).with("The get_new_build_number plugin is working!")

      Fastlane::Actions::GetNewBuildNumberAction.run(nil)
    end
  end
end
