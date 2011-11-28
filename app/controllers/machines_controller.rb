class MachinesController < ApplicationController
layout 'adminlayout' 
 before_filter :login_required
#DISPLAYING LIST BASED ON SELECTED VALUES 
def search
    begin
     p "in search"
    @session['groupcluster']=nil 
    @session['groupshop']=nil
    @session['groupkey']=nil 
        p params[:machine][:ClusterName]
        p params[:machine][:ShopName]
        p params[:machine][:GroupID]
        if(params[:machine][:ClusterName]=="")
        @session['groupcluster']=@session[:clustername]
        else
        @session['groupcluster']=params[:machine][:ClusterName]
        end
    
        if(params[:machine][:ShopName]=="")
        @session['groupshop']=@session[:shopname]
        else
        @session['groupshop']=params[:machine][:ShopName]
        end
    
        if(params[:machine][:GroupID]=="")
        @session['groupkey']=@session[:Groupid]
        else
        @session['groupkey']=params[:machine][:GroupID]
        end
    
    
   
    
        redirect_to :action=>'list'
    rescue Exception=>ex
    end
end


#REFRESHING PARTIAL FOR GETTING SHOPS UNDER SELECTED GROUP
def getShop
    begin
    puts "IN getSHOP"
   puts params[:ClusterName]
    session[:shopname]=nil
    @session[:clustername]=params[:ClusterName]
    render :update do |page|
	  page.replace_html 'ShopNamediv', :partial => 'shopname'
  end
  rescue Exception=>ex
  puts ex.message()
  end
end
 
 
 #REFRESHING PARTIAL FOR GETTING KEYS UNDER SELECTED SHOP
 def getGroup
     puts "getGroup"
     puts params[:ShopName]
     session[:shopname]=params[:ShopName]
     render :update do |page|
	  page.replace_html 'KeyIDdiv', :partial => 'groupID'
    end
end

 



 def index
    list
    render :action => 'list'
  end

  # GETs should be safe (see http://www.w3.org/2001/tag/doc/whenToUseGet.html)
  verify :method => :post, :only => [ :destroy, :create, :update ],
         :redirect_to => { :action => :list }

  def list
=begin
puts @session['groupcluster']
 puts @session['groupshop']
 puts @session['groupkey'] 
    @machines1=Machine.find_all(["ClusterName=? and ShopName=? and GroupID=?",@session['groupcluster'],@session['groupshop'],@session['groupkey']]) 
    puts @machine1
    if(@machines1==nil)
        puts "DATA FOUND"
        
    else
        puts "DATA NOT FOUND"
    end
=end   
      
    @machine_pages, @machines = paginate :machines, :per_page => 10
  end

  def show
    @machine = Machine.find(params[:id])
  end

  def new
    @machine = Machine.new
    session[:shopid]=nil
  end

#ADDED A NEW MACHINE 
########CONDITION FOR CHECKING MAXIMUM 6 MACHINES CAN BE ADDED UNDER ONE SINGLE KEY

  def create
    begin
    puts "in create of Machine"
    if(params[:machine][:ClusterName]==nil or params[:machine][:ClusterName]=="")
        params[:machine][:ClusterName]=@session[:clustername]
    end
    
    if(params[:machine][:ShopName]==nil or params[:machine][:ShopName]=="")
        params[:machine][:ShopName]=@session[:shopname]
    end
    
    if(params[:machine][:GroupID]==nil or params[:machine][:GroupID]=="")
        params[:machine][:GroupID]=@session[:Groupid]
    end
    
    
    puts params[:machine][:ClusterName]
    puts params[:machine][:ShopName]
    puts params[:machine][:GroupID]
    puts params[:machine][:MachineNo]
    puts params[:machine][:MachineName]
    
     puts params[:machine][:MachineType]
    
    @machine = Machine.new(params[:machine])
    
       # if(params[:machine][:MachineNo].to_i>6)
               # @m=Machine.count(["ShopName=? and ClusterName=? and  GroupID=?",params[:machine][:ShopName],params[:machine][:ClusterName],params[:machine][:GroupID]])
               # puts @m
               # if(@m<6)
                    #@max=Machine.MAX(["ShopName=? and ClusterName=? and  GroupID=?",params[:machine][:ShopName],params[:machine][:ClusterName],params[:machine][:GroupID]])
                   #@max=Machine.find_by_sql("select max(MachineNo) as 'max' from machines where ShopName= '#{params[:machine][:ShopName]}' and ClusterName='#{params[:machine][:ClusterName]}' and  GroupID='#{params[:machine][:GroupID]}'")
                    
                    #puts @max[0].max
                    #if(@max[0].max
                   # flash[:notice]="<font color=red>PLEASE ADD ABOVE 6 MACHINENO UNDER ANOTHER KEY</font>"
                   # render :action=>'new'
                
               # else
                   # flash[:notice]="<font color=red>PLEASE7777777 ADD ABOVE 6 MACHINENO UNDER ANOTHER KEY</font>"
                   # render :action=>'new'
                
                    #puts "in else"
                    #if @machine.save
                      # flash[:notice] = 'MACHINE WAS SUCCESSFULLY CREATED.'
                        #redirect_to :action => 'list'
                   # render :action => 'new'
                   # end
               # end
        #else
        
    
        @checkmc=Machine.find_first(["ClusterName=? and ShopName=? and GroupID=? and MachineNo=?",params[:machine][:ClusterName],params[:machine][:ShopName],params[:machine][:GroupID], params[:machine][:MachineNo]])
        @checkmcname=Machine.find_first(["ClusterName=? and ShopName=? and GroupID=? and MachineName=?",params[:machine][:ClusterName],params[:machine][:ShopName],params[:machine][:GroupID], params[:machine][:MachineName]])
            if(@checkmc!=nil)
                flash[:notice]='<font color=red size=3><b>ENTERED MACHINE NO ALREADY EXISTS, PLEASE ENTER NEW MACHINE NO</B></FONT>'
                flash[:confirm]=nil
                render :action=>'new'
           # elsif(@checkmcname!=nil)
            #    flash[:notice]='<font color=red size=3><b>ENTERED MACHINE NAME ALREADY EXISTS, PLEASE ENTER NEW MACHINE NO</B></FONT>'
             #   flash[:confirm]=nil
              #  render :action=>'new'
            else
              
              
              
            if @machine.save
                        flash[:confirm] = '<font color=green size=3><b>MACHINE WAS SUCCESSFULLY CREATED.</b></font>'
                        flash[:notice]= nil
                        #redirect_to :action => 'list'
                        render :action => 'new'
            else
                        render :action => 'new'
                    end
            end
        #end
    rescue Exception=>ex
        puts ex.message
    end
end

  def edit
    @machine = Machine.find(params[:id])
  end


#METHOD FOR UPDATING MACHINE DATA ALREADY CREATED
  def update
      puts params[:machine][:MachineType]
    @machine = Machine.find(params[:id])
    if @machine.update_attributes(params[:machine])
      flash[:notice] = 'Machine was successfully updated.'
      redirect_to :action => 'list', :id => @machine
    else
      render :action => 'edit'
    end
  end

#DELETING MACHINE
  def destroy
    Machine.find(params[:id]).destroy
    redirect_to :action => 'list'
end

#CANCELING ADD OPERATION AND REDIRECTING TO LIST SCREEN
 def canceladd
      @session['groupcluster']=nil 
 @session['groupshop']=nil
 @session['groupkey']=nil 
    render :update do |page|
    page.redirect_to url_for(:controller=>'machines', :action=>'list')
    end
    end
end
