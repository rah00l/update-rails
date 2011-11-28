class Group < ActiveRecord::Base
    belongs_to :shop
    validates_presence_of :ClusterName, :on=> :create
    validates_presence_of  :ClusterName,  :on => :update
    
    
    
    validates_presence_of :ShopName, :on=> :create
    validates_presence_of :ShopName, :on=> :update
    
   
    
end
