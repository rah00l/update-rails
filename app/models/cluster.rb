class Cluster < ActiveRecord::Base
    
    validates_presence_of  :ClusterName,  :on => :create
    validates_presence_of  :ClusterName,  :on => :update
   
    validates_format_of :ClusterName,
    :with => /^[A-Z a-z 0-9]*\z/ ,
    :on => :create
      
    validates_format_of :ClusterName,
    :with => /^[A-Z a-z 0-9]*\z/ ,
    :on => :update
    
    validates_length_of :ClusterName, 
    :maximum  => 50,  
    :on => :create
    
    validates_length_of :ClusterName, 
    :maximum  => 50,  
    :on => :update
    
    
    validates_uniqueness_of :ClusterName, :on=> :create
    validates_uniqueness_of :ClusterName, :on=> :update
    
 
end
