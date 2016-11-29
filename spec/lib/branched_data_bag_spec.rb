require File.expand_path('../../spec_helper.rb', __FILE__)

RSpec.describe ChefGit::BranchedDataBag do

  context 'is on master' do
    before do
      allow_any_instance_of(ChefGit::BranchedDataBag).to receive(:chef_git_environment).and_return('master')
    end

    it 'returns the data bag name if on master' do
      expect(ChefGit::BranchedDataBag.bag_name('foo')).to eq('foo')
    end
  end

  context 'data bag differs from master' do
    before do
      allow_any_instance_of(ChefGit::BranchedDataBag).to receive(:chef_git_environment).and_return('notmaster')
      allow_any_instance_of(Mixlib::ShellOut).to receive(:stdout).and_return('something')
      Dir.stub(:chdir).and_yield
    end

    it 'returns the data bag name prefixed by the branch' do
      expect(ChefGit::BranchedDataBag.bag_name('foo')).to eq('notmaster__foo')
    end
  end

  context 'data bag does not differ from master' do
    before do
      allow_any_instance_of(ChefGit::BranchedDataBag).to receive(:chef_git_environment).and_return('notmaster')
      allow_any_instance_of(Mixlib::ShellOut).to receive(:stdout).and_return('')
      allow_any_instance_of(Mixlib::ShellOut).to receive(:stderr).and_return('')
      allow_any_instance_of(Mixlib::ShellOut).to receive(:error?).and_return(false)
      Dir.stub(:chdir).and_yield
    end

    it 'returns the data bag name prefixed by the branch' do
      expect(ChefGit::BranchedDataBag.bag_name('foo')).to eq('foo')
    end

  end
end
