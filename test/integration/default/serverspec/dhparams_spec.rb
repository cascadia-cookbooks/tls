require 'spec_helper'

describe 'cop_tls::dhparams' do
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

  describe file('/etc/ssl/certs/dhparams.pem') do
    it { should be_file }
    it { should be_owned_by 'root' }
    it { should be_grouped_into 'root' }
    it { should be_mode 644 }
    its(:content) { should match /BEGIN DH PARAMETERS/ }
    its(:content) { should match /END DH PARAMETERS/ }
  end

  describe file('/tmp/dhparams.pem') do
    it { should be_file }
    it { should be_owned_by 'root' }
    it { should be_grouped_into 'root' }
    it { should be_mode 644 }
    its(:content) { should match /BEGIN DH PARAMETERS/ }
    its(:content) { should match /END DH PARAMETERS/ }
  end
end
