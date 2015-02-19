require 'spec_helper'
describe 'eyaml' do

  context 'with defaults for all parameters' do
    it { should contain_class('eyaml') }
  end
end
