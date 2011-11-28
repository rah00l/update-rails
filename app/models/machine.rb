class Machine < ActiveRecord::Base
    #validates_uniqueness_of :MachineName, :on=>:create
    #validates_uniqueness_of :MachineName, :on=>:update
    
    
   validates_presence_of :MachineNo, :on=>:update
   validates_presence_of :MachineNo, :on=>:create
   
   validates_format_of :MachineNo,
  :with => /^[A-Z a-z 0-9]*\z/ ,
  :on => :create
  
validates_format_of :MachineNo,
  :with => /^[A-Z a-z 0-9]*\z/ ,
  :on => :update
    
    
    validates_length_of :MachineNo,
    :maximum => 5, :on => :create
    
    validates_length_of :MachineNo,
    :maximum => 5, :on => :update
    
    validates_length_of :MachineName,
    :maximum => 10, :on => :create
    
    
    validates_length_of :MachineName,
    :maximum => 10, :on => :update
    
    #validates_presence_of :MachineName, :on=>:update
    #validates_presence_of :MachineName, :on=>:create
    
    
    #validates_presence_of :ScreenIn, :on=>:update
    #validates_presence_of :ScreenIn, :on=>:create
    
    #validates_presence_of :ScreenOut, :on=>:create
    #validates_presence_of :ScreenOut, :on=>:update
    
    #validates_presence_of :MeterIn, :on=>:update
    #validates_presence_of :MeterIn, :on=>:create
    
    #validates_presence_of :MeterOut, :on=>:create
    #validates_presence_of :MeterOut, :on=>:update
    
end
