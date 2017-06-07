require 'spec_helper'

describe 'cop_tls::snakeoil' do
  describe file('/etc/ssl') do
    it { should be_directory }
    it { should be_owned_by 'root' }
    it { should be_grouped_into 'root' }
    it { should be_mode 755 }
  end

  describe file('/etc/ssl/certs') do
    it { should be_directory }
    it { should be_owned_by 'root' }
    it { should be_grouped_into 'root' }
    # NOTE: in some installations this can be a symlink, which is 777
    #       we can skip this check
    #it { should be_mode 755 }
  end

  describe file('/etc/ssl/certs/test.localhost.com.crt') do
    it { should be_file }
    it { should be_owned_by 'root' }
    it { should be_grouped_into 'root' }
    it { should be_mode 700 }
    its(:content) { should match /BEGIN CERTIFICATE/ }
    its(:content) { should match /END CERTIFICATE/ }
  end

  describe file('/etc/ssl/private/test.localhost.com.key') do
    it { should be_file }
    it { should be_owned_by 'root' }
    it { should be_grouped_into 'root' }
    it { should be_mode 700 }
    its(:content) { should match /BEGIN PRIVATE KEY/ }
    its(:content) { should match /END PRIVATE KEY/ }
  end

  describe command('sudo openssl x509 -in /etc/ssl/certs/test.localhost.com.crt -text -noout') do
    its(:stdout) { should match /C=US/ }
    its(:stdout) { should match /ST=Oregon/ }
    its(:stdout) { should match /L=Portland/ }
    its(:stdout) { should match /O=Copious/ }
    its(:stdout) { should match /OU=Devoops/ }
    its(:stdout) { should match /CN=test\.localhost\.com/ }
  end
end
