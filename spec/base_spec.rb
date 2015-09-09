require 'authorizer/base'

RSpec.describe Authorizer::Base do
  
  context '#public_instance_methods' do
    subject { Authorizer::Base.public_instance_methods }
  
    it 'include #user' do
      expect(subject.include?(:user)).to be(true)
    end
  
    it 'include #record' do
      expect(subject.include?(:record)).to be(true)
    end
  
    it 'include #affiliation' do
      expect(subject.include?(:affiliation)).to be(true)
    end
  
    it 'include #organization' do
      expect(subject.include?(:organization)).to be(true)
    end
  end
  
  describe 'using Authorizer objects' do
    let(:user) { double }
    let(:organization) { double }
    let(:affiliation) { Affiliation.new(organization, user) }
    let(:post) { Post.new() }
    let(:post_authorizer) { PostAuthorizer.new(user, affiliation, organization, post) }
    
    it '#user' do
      expect(post_authorizer.user).to eq(user)
    end
    
    it '#affiliation' do
      expect(post_authorizer.affiliation).to eq(affiliation)
    end
    
    it '#organization' do
      expect(post_authorizer.organization).to eq(organization)
    end
    
    it '#record' do
      expect(post_authorizer.record).to eq(post)
    end
    
    
    context 'invoking existing authorization methods' do
      it '#read?' do
        expect(post_authorizer.read?).to be(true)
      end
      
      it '#edit?' do
        expect(post_authorizer.edit?).to be(false)
      end
    end
    
    context 'invoking non-existing authorization methods' do
      context 'in rails DEVELOPMENT environment' do
        Rails = Class.new do
          def self.env
            Class.new do
              def self.development?; true; end
              def self.test?; false; end
            end
          end
        end
        
        it '#non_existent?' do
          expect { post_authorizer.non_existent? }.to raise_error(RuntimeError)
        end
      end
      
      context 'in rails TEST environment' do
        Rails = Class.new do
          def self.env
            Class.new do
              def self.development?; false; end
              def self.test?; true; end
            end
          end
        end

        it '#non_existent?' do
          expect { post_authorizer.non_existent? }.to raise_error(RuntimeError)
        end
      end
    end
    
  end
  
end