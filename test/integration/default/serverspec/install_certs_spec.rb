require 'spec_helper'

describe 'cop_tls::install_certs' do
  describe file('/etc/ssl/certs/test.localhost.org.crt') do
    it { should be_file }
    it { should be_owned_by 'root' }
    it { should be_grouped_into 'root' }
    it { should be_mode 644 }
    its(:content) { should match /certificate goes here/ }
  end

  describe file('/etc/ssl/private/test.localhost.org.key') do
    it { should be_file }
    it { should be_owned_by 'root' }
    it { should be_grouped_into 'root' }
    it { should be_mode 600 }
    its(:content) { should match /private key goes here/ }
  end
end
