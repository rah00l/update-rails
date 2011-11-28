class GroupsController < ApplicationController
  layout 'adminlayout'
   before_filter :login_required
#REDIRECTING TO LIST SCREEN ON PERFORMING SEARCH
def search
    begin
    @session['groupcluster']=params[:group][:ClusterName]
    @session['groupshop']=params[:group][:ShopName]
    redirect_to :action=>'list'
    rescue Exception=>ex
        ex.message
    end
end


#CREATING METHOD FOR CREATING A NEW KEY 
def create
 begin   
    if params[:group1][:GroupID]!=""
    
        if params[:group1][:GroupID]=='KEY 1'
          
            params[:group][:GroupID]=params[:group1][:GroupID]
            puts "During key1 selection"
            @g=Group.find_first(["GroupID='KEY 1' and ShopName=? and ClusterName=?",params[:group][:ShopName],params[:group][:ClusterName]])
            if(@g==nil)
            @group1 = Group.new(params[:group])
            if(@group1.save)
                # flash[:confirm]="<font color=green size=3><b>KEY GENERATED SUCCESSFULLY</b></font> "
                
                 #render :action=>'new'
            end
            else 
                puts "Record already exists"
            end
        end
        
        if params[:group2][:GroupID]=='KEY 2'
          
            params[:group][:GroupID]=params[:group2][:GroupID]
            puts "During key2 selection"
             @g=Group.find_first(["GroupID='KEY 2' and ShopName=? and ClusterName=?",params[:group][:ShopName],params[:group][:ClusterName]])
            if(@g==nil)
           
            @group2 = Group.new(params[:group])
            
            if(@group2.save)
                   #flash[:confirm]="<font color=green size=3><b>KEY GENERATED SUCCESSFULLY</b></font> "
                # render :action=>'new'
            end
            end
        end
        
        if params[:group3][:GroupID]=='KEY 3' 
          
            params[:group][:GroupID]=params[:group3][:GroupID]
              puts "During key3 selection"
             @g=Group.find_first(["GroupID='KEY 3' and ShopName=? and ClusterName=?",params[:group][:ShopName],params[:group][:ClusterName]])
            if(@g==nil)
           
            puts "During key3 selection"
            @group3 = Group.new(params[:group])
           if(@group3.save)
                   #flash[:confirm]="<font color=green size=3><b>KEY GENERATED SUCCESSFULLY</b></font> "
                 #render :action=>'new'
            end
            end
        end
    
        if params[:group4][:GroupID]=='KEY 4' 
          puts "During key4 selection"
            params[:group][:GroupID]=params[:group4][:GroupID]
            
             @g=Group.find_first(["GroupID='KEY 4' and ShopName=? and ClusterName=?",params[:group][:ShopName],params[:group][:ClusterName]])
            if(@g==nil)
                @group4 = Group.new(params[:group])
                if(@group4.save)
                 #flash[:confirm]="<font color=green size=3><b>KEY GENERATED SUCCESSFULLY</b></font> "
                 #render :action=>'new'
            end
            end
        
        end
    
end
      
      if params[:group1][:GroupID]=='0'
          @s=Group.find_first(["ShopName=? and GroupID='KEY 1'",params[:group][:ShopName]])
            puts "KEY1 0"
            if(@s!=nil)
            @s.destroy
            end
        end
        
        
        
        if params[:group2][:GroupID]=='0'
          @s=Group.find_first(["ShopName=? and GroupID='KEY 2'",params[:group][:ShopName]])
            puts "KEY2 0"
            if(@s!=nil)
            @s.destroy
            end
        end
        
       if params[:group3][:GroupID]=='0'
          @s=Group.find_first(["ShopName=? and GroupID='KEY 3'",params[:group][:ShopName]])
           puts "KEY3 0"
            if(@s!=nil)
            @s.destroy
            end
        end
     if params[:group4][:GroupID]=='0'
          @s=Group.find_first(["ShopName=? and GroupID='KEY 4'",params[:group][:ShopName]])
           puts "KEY4 0"
            if(@s!=nil)
            @s.destroy
            end
            
    end 
        #@session[:byshopid]=params[:group][:ShopID]
    
        @session[:clustername1]=nil
        @session[:clustername]=nil
        @session[:shopname]=nil
        
        puts "---------------------------------------"
        puts params[:group][:ClusterName]
        puts "---------------------------------------"
        if params[:group][:ClusterName]!="" 
          #flash[:confirm]="<font color=green size=3><b>#{params[:group][:ShopName]}</b></font> "
           flash[:confirm]="<font color=green size=3><b>KEY GENERATED SUCCESSFULLY</b></font> "
          end
        #redirect_to :action => 'new'
        render :action=>'new'
        
    
rescue Exception=>ex
    puts ex.message
end
end
    
 #.......................................................................method closed...............................................................   
 

#METHOD FOR GETTING SHOPNAME ON SELECTING GROUP
 def getShopName
   begin
   puts "gggggggggggggggggggggggggggg"
    puts params[:ClusterName]
    puts "at getShopeName Method......"
    @shop=Shop.find_first(["ClusterName=?",params[:ClusterName]])
    
    @session[:clustername]=params[:ClusterName]
    
    render :update do |page|
        page.replace_html 'shopnamediv', :partial => 'shopname'
    end
    
    rescue Exception=>exc
        puts exc.message
    end
end

def getShopName1
   begin
   puts "gggggggggggggggggggggggggggg"
    puts params[:ClusterName]
    puts "at getShopeName Method......"
    @shop=Shop.find_first(["ClusterName=?",params[:ClusterName]])
    
    @session[:clustername]=params[:ClusterName]
    
    render :update do |page|
        page.replace_html 'shopnamediv', :partial => 'addshopname'
    end
    
    rescue Exception=>exc
        puts exc.message
    end
end

#PERFORMING UPDATE METHOD 
def update
      begin
    puts "VALUES ARE"
    puts params[:group1][:GroupID]
    puts params[:group2][:GroupID]
    puts params[:group3][:GroupID]
    puts params[:group4][:GroupID]
    
    
    if params[:group1][:GroupID]=='KEY 1'
            puts "KEY1"
            @s=Group.find_first(["ShopName=? and GroupID=?",params[:group][:ShopName],params[:group1][:GroupID]])
           
            if(@s==nil)
            params[:group][:GroupID]=params[:group1][:GroupID]
            puts "During key1 selection"
            @group1 = Group.new(params[:group])
            @group1.save
            end
    end
    


    
    if params[:group2][:GroupID]=='KEY 2'
           @s=Group.find_first(["ShopName=? and GroupID=?",params[:group][:ShopName],params[:group2][:GroupID]])
           puts "KEY2"
            if(@s==nil)
            params[:group][:GroupID]=params[:group2][:GroupID]
            puts "During key2 selection"
            @group1 = Group.new(params[:group])
            @group1.save
            end
    end
        
    if params[:group3][:GroupID]=='KEY 3'
        
          @s=Group.find_first(["ShopName=? and GroupID=?",params[:group][:ShopName],params[:group3][:GroupID]])
            puts "KEY3"
            if(@s==nil)
            params[:group][:GroupID]=params[:group3][:GroupID]
            puts "During key3 selection"
            
            @group1 = Group.new(params[:group])
            @group1.save
            end
    end  

    if params[:group4][:GroupID]=='KEY 4'
          @s=Group.find_first(["ShopName=? and GroupID=?",params[:group][:ShopName],params[:group4][:GroupID]])
            puts "KEY4"
            if(@s==nil)
            params[:group][:GroupID]=params[:group4][:GroupID]
            puts "During key4 selection"
            @group1 = Group.new(params[:group])
            @group1.save
            end
            
        end 


        if params[:group1][:GroupID]=='0'
          @s=Group.find_first(["ShopName=? and GroupID='KEY 1'",params[:group][:ShopName]])
            puts "KEY1 0"
            if(@s!=nil)
            @s.destroy
            end
        end
        if params[:group2][:GroupID]=='0'
          @s=Group.find_first(["ShopName=? and GroupID='KEY 2'",params[:group][:ShopName]])
            puts "KEY2 0"
            if(@s!=nil)
            @s.destroy
            end
        end
        
       if params[:group3][:GroupID]=='0'
          @s=Group.find_first(["ShopName=? and GroupID='KEY 3'",params[:group][:ShopName]])
           puts "KEY3 0"
            if(@s!=nil)
            @s.destroy
            end
        end
     if params[:group4][:GroupID]=='0'
          @s=Group.find_first(["ShopName=? and GroupID='KEY 4'",params[:group][:ShopName]])
           puts "KEY4 0"
            if(@s!=nil)
            @s.destroy
            end
        end    
          
    
  
    
    redirect_to :action => 'list'
    rescue Exception=>ex
    puts ex.message
  end
end

    def index
        list
        render :action => 'list'
    end

  # GETs should be safe (see http://www.w3.org/2001/tag/doc/whenToUseGet.html)
  verify :method => :post, :only => [ :destroy, :create, :update ],
         :redirect_to => { :action => :list }

  #METHOD FOR LISTING CLUSTERNAME
  def list
    @session[:clustername]=nil
    @session[:clustername1]=nil
    @group_pages, @groups = paginate :groups, :per_page => 10
  end

  def show
    @group = Group.find(params[:id])
  end

  def new
    @group = Group.new
  end

  def edit
      @group = Group.find(params[:id])
  end

def delete
    puts "in delete"
    @a=Group.find(params[:id])
    if(@a!=nil)
    puts @a.id
   
    @m=Machine.find_first(["ShopName=? and ClusterName=? and GroupId=?",@a.ShopName,@a.ClusterName,@a.GroupID])
    if(@m!=nil)
       
        flash[:notice]='<font color=green size=3><b>CANNOT DELETE KEY AS MAPPED TO A MACHINE</b></font>'
        render :action=>'list'
       puts "ReCORDS FOUND"
    else
        Group.find(params[:id]).destroy
        redirect_to :action => 'list'
    end
    end
    #@m1=Machine.find_first(["ShopName=? and ClusterName=? and GroupId='KEY 1'","#{@session['groupshop']}","#{@session['groupcluster']}"]) %>

    #Group.find(params[:id]).destroy
    #redirect_to :action => 'list'
 end

#REDIRECTING TO SEARCH SCREEN ON PERFORMING CANCEL OPERATION  
def canceladd
    render :update do |page|
    page.redirect_to url_for(:controller=>'groups', :action=>'search')
    end
    end
end
