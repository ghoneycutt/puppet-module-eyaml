require 'spec_helper'
describe 'eyaml' do

  puppetversions = {
   '3' => {
      :package_provider => 'gem',
      :path_prefix      => '/etc/puppet',
    },
    '4' => {
      :package_provider => 'puppet_gem',
      :path_prefix      => '/etc/puppetlabs',
    },
  }

  describe 'with defaults for all parameters' do
    puppetversions.sort.each do |k,v|
      context "on puppet v#{k}" do
        let(:facts) { { :puppetversion => "#{k}.0.0" } }

        it { should contain_class('eyaml') }

        it do
          should contain_package('eyaml').with(
            'ensure'   => 'present',
            'name'     => 'hiera-eyaml',
            'provider' => v[:package_provider],
          )
        end

        it do
          should contain_file('eyaml_config_dir').with(
            'ensure'  => 'directory',
            'path'    => '/etc/eyaml',
            'owner'   => 'root',
            'group'   => 'root',
            'mode'    => '0755',
            'require' => 'Package[eyaml]',
          )
        end

        it do
          should contain_file('eyaml_config').with(
            'ensure'  => 'file',
            'path'    => '/etc/eyaml/config.yaml',
            'owner'   => 'root',
            'group'   => 'root',
            'mode'    => '0644',
            'require' => 'File[eyaml_config_dir]',
          )
        end

        it do
          should contain_file('eyaml_config').with_content(
            %r{^(.*)pkcs7_private_key:(.+)"?#{v[:path_prefix]}/keys/private_key\.pkcs7\.pem"?$}
          )
        end

        it do
          should contain_file('eyaml_config').with_content(
            %r{^(.*)pkcs7_public_key:(.+)"?#{v[:path_prefix]}/keys/public_key\.pkcs7\.pem"?$}
          )
        end

        it do
          should contain_file('eyaml_keys_dir').with(
            'ensure'  => 'directory',
            'path'    => "#{v[:path_prefix]}/keys",
            'owner'   => 'root',
            'group'   => 'root',
            'mode'    => '0500',
            'require' => 'Package[eyaml]',
          )
        end

        it do
          should contain_exec('eyaml_createkeys').with(
            'path'    => '/bin:/usr/bin:/sbin:/usr/sbin:/usr/local/bin',
            'command' => "eyaml createkeys --pkcs7-private-key=#{v[:path_prefix]}/keys/private_key.pkcs7.pem --pkcs7-public-key=#{v[:path_prefix]}/keys/public_key.pkcs7.pem",
            'creates' => "#{v[:path_prefix]}/keys/private_key.pkcs7.pem",
            'require' => 'File[eyaml_keys_dir]',
          )
        end

        it do
          should contain_file('eyaml_publickey').with(
            'ensure'  => 'file',
            'path'    => "#{v[:path_prefix]}/keys/public_key.pkcs7.pem",
            'owner'   => 'root',
            'group'   => 'root',
            'mode'    => '0644',
            'require' => 'Exec[eyaml_createkeys]',
          )
        end

        it do
          should contain_file('eyaml_privatekey').with(
            'ensure'  => 'file',
            'path'    => "#{v[:path_prefix]}/keys/private_key.pkcs7.pem",
            'owner'   => 'root',
            'group'   => 'root',
            'mode'    => '0400',
            'require' => 'Exec[eyaml_createkeys]',
          )
        end
      end
    end
  end
end
