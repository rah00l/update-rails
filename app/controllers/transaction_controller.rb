class TransactionController < ApplicationController
     layout 'adminlayout'
  before_filter :login_required
#Method for creating data to be sent to server 
#whose data of all machines filled in Transaction 
#table according to the date selected

def showshop
   render :update do |page|
            page.replace_html 'shoplistdiv', :partial => 'shoplist'
    end 
end


def getdate
    puts "in getdate"
    puts params[:Date]
    @session['shopdate']=params[:Date]
     render :update do |page|
        page.redirect_to url_for(:controller=>'transactions', :action=>'createdata')
    end 
end


def cleardate1
     render :update do |page|
        page.redirect_to url_for(:controller=>'transactions', :action=>'cleardata')
    end 
end


def dateselect
     s=[]
     @session['shopdate']=nil
    puts params[:Date]
   
     @session['shopdate']=params[:Date]
     #redirect_to :controller=>'transactions',:action=>'cleardata1'
     #render :update do |page|
     #page.redirect_to url_for(:controller=>'transactions', :action=>'cleardata')
     #end 
end

def refreshmaster
    
    render :update do |page|
    page << "document.getElementById('aux_div').style.visibility = 'visible'"
    page.alert "Data send to server properly"
    page.redirect_to url_for(:action=>'new')
    
    end                      
end
=begin
def showdata1
  puts "hi--------------------"
   puts "Date-------"
         puts params[:datevalue]
         session[:dateval]=params[:datevalue]
         puts session[:dateval]
          #render :update do |page|
            #  page.replace_html('griddisp',:partial=>'edetails')
            #end 
            #redirectmethod
     end
=end
def showdata
    puts params[:datevalue]
    session[:dateval]=params[:datevalue]
    render :update do |page|
      page.replace_html('griddisp',:partial=>'edetails')
    end 
end
  
=begin
def redirectmethod
  render :update do |page|
    page.replace_html('griddisp',:partial=>'edetails')
  end 
    puts session[:dateval]
end
=end

#DATA WILL BE SEND TO SERVER AND DUMPPED IN .SQL BACKUP FILE
def createdata
    begin
         p params[:transactions][:ShopName]
        
    @t= Transaction.find(:all,:conditions=>["ShopName in (?) and status=0",params[:transactions][:ShopName]])
                            	  @t.each do |c| 
                            	    c.status=1 
                            	     c.save 
                                 end
    #create a sql file for uploading
      puts "date"
     date=Time.now().strftime("%Y%m%d")
     puts date
     
      @cluster=Shop.find_first(["ShopName=?",params[:transactions][:ShopName]])
        puts "CLUSTERNAME"
        puts @cluster.ClusterName
        
    
      fname="#{@cluster.ClusterName}_#{params[:transactions][:ShopName]}_"+date+".sql"
      total=0
      count=0
      @t= Transaction.find(:all,:conditions=>["ShopName in (?) and status=1 ",params[:transactions][:ShopName]])
      

        FasterCSV.open(fname, "w") do |csv|
           
           
                for sname in @t
                    #csv<< sname.ShopName+","+sname.GroupID+","+sname.MachineNo+","+sname.MachineName
                     @a=[sname.ClusterName,sname.ShopName,sname.Date,sname.GroupID,sname.MachineNo,sname.ScreenIN,sname.ScreenOUT,sname.MeterIN,sname.MeterOUT,sname.Machineshort,sname.Shortreason,sname.status]
                     csv<< @a
                     
                     
                    
                end
        end 

    pw=Dir.pwd()
    Dir.chdir(pw)
    filename=pw.to_s+"/"+fname
    
=begin 
/*
    s=[]
    fp= File.open(filename, "r") 
        while(fp.eof!=true)
        s<<fp.readline
        
        end
     
     for i in 0..(s.length-1)
     a= s[i].to_s.split(',')
     puts a
     @e=Transaction.new
     @e.ShopName=a[0]
     @e.save
     p "------------"
     end
*/
=end
     

            
    render :update do |page|
    page << "document.getElementById('aux_div').style.visibility = 'visible'"
    page.redirect_to url_for(:controller=>'transactions', :action=>'new')
    end              
    rescue Exception=>ex
    puts ex.message
    end

end




def cleardata
end
def missingrecordslist
    puts "missing records"
    puts params[:Transaction][:ShopName]
    #puts params[:Transaction_Date]
    puts @session[:shopname]
    if(params[:Transaction][:ShopName]==""  and @session[:shopname]==nil)
        puts "in if"
        session[:errmsg]="Please select ShopName"
            render :update do |page|
                page.redirect_to url_for(:controller=>'transaction', :action=>'new')
            end 
    else
        if(params[:Transaction][:ShopName]=="")
            @session['shop']=@session[:shopname]
        else
        @session['shop']=params[:Transaction][:ShopName]
        end
        @session['date']=params[:Transaction][:Date]
        @session['date']=Date.parse(@session['date'])
        render :update do |page|
            page.redirect_to url_for(:controller=>'transaction', :action=>'missingrecords')
        end
    end 
end



def saveshort
    begin
    p "IN SAVESHORT"
    puts @session['shortshop']
     
     @s=Transaction.find_first(["ShopName=? and GroupID=? and MachineName=? and Date=?",@session['shortshop'],@session['shortgroupid'],@session['shortmachinename'],@session['shortdate']])    
                            if(@s!=nil)
                                if(params[:Transaction][:Machineshort]==nil)
                                   session[:errmsg]="Please select ShopID"
                                redirect_to :controller=>'transactions',:action => 'short'
                                #render :update do |page|
                                    #page.redirect_to url_for(:controller=>'transactions', :action=>'short')
                                #end
                                elsif(params[:Transaction][:Shortreason]==nil)
                                   session[:errmsg]="Please select ShopID"
                                p "nil value for reason"
                                #render :update do |page|
                                 #   page.redirect_to url_for(:controller=>'transactions', :action=>'short')
                                #end
                                redirect_to :controller=>'transaction',:action => 'short'
                                else
                                    
                                puts "in else"
                                @s.Machineshort=params[:Transaction][:Machineshort]
                                @s.Shortreason=params[:Transaction][:Shortreason]
                                @s.save
                                #render :update do |page|
                                    #page.redirect_to url_for(:controller=>'transactions', :action=>'dataTransaction')
                                #end 
                                redirect_to :controller=>'transaction',:action => 'new'
                                end
                            else
                                 render :update do |page|
                                    page.alert("Please Enter its details first")
                                    page.redirect_to url_for(:controller=>'transaction', :action=>'new')
                                end
                            end
                            
        rescue Exception=>ex
            puts ex.message
        end
end

#SHORT REASON CODE FOR ENTRING THE SHORTS FOR SPECIFIC MACHINE
def checkshort
    begin
        puts "in short"
            #@session['shortgroupid']=nil
            #@session['shortmachinename']=nil
            #@session['shortshop']=nil
            #@c =Transaction.count(["ShopName=? and Date=? ",params[:Transaction][:ShopName],params[:Transaction_Date]])  #Transaction COUNT WITH GIVEN SHOPID AND DATE  
            puts params[:Transaction][:ShopName]==""
            puts @session[:shopname]
            if(params[:Transaction][:ShopName]=="" and @session[:shopname]==nil) #IF SHOPID NOT SELECTED THEN 
                puts "in ERROR"
                session[:errmsg]="Please select ShopID"
                
                render :update do |page|
                    page.redirect_to url_for(:controller=>'transaction', :action=>'new')
                end 
            elsif(params[:Transaction][:GroupID]=="" and @session[:Groupid]==nil)#IF SHOPID NOT SELECTED THEN 
                puts "in ERROR"
                session[:errmsg]="Please select GroupID"
                
                render :update do |page|
                    page.redirect_to url_for(:controller=>'transaction', :action=>'new')
                end 
            elsif(params[:Transaction][:MachineName]=="" and @session[:MachineNo]==nil) #IF SHOPID NOT SELECTED THEN 
                puts "in ERROR"
                session[:errmsg]="Please select MachineNo"
                
                render :update do |page|
                    page.redirect_to url_for(:controller=>'transaction', :action=>'new')
                end  
            else
                puts "DATA IS"
                puts @session[:shopname]
                puts @session[:Groupid]
                puts @session[:MachineName]
                
                
                puts params[:Transaction][:ShopName]
                if(params[:Transaction][:GroupID]==nil or  params[:Transaction][:GroupID]=="")
                    @session['shortgroupid']=@session[:Groupid]
                else              
                @session['shortgroupid']=params[:Transaction][:GroupID]
                end
                
                if(params[:Transaction][:MachineName]==nil or params[:Transaction][:MachineName]=="")
                    @session['shortmachinename']=@session[:MachineName]
                else              
                 @session['shortmachinename']=params[:Transaction][:MachineName]
                end
                
                 if(params[:Transaction][:ShopName]=="" or params[:Transaction][:ShopName]==nil)
                    @session['shortshop']=@session[:shopname]
                else              
                @session['shortshop']=params[:Transaction][:ShopName]
                end
               puts "short data"
               puts @session['shortshop']
               puts @session['shortgroupid']
               puts @session['shortmachinename']
               
               
               
               
                @session['shortdate']=Date.parse(params[:Transaction][:Date])
                 @date=Date.parse(params[:Transaction][:Date])
                @s=Transaction.find_first(["ShopName=? and GroupID=? and MachineName=? and Date=?",@session['shortshop'],@session['shortgroupid'],@session['shortmachinename'],@date])        
                    if(@s!=nil)
                    render :update do |page|
                    page.redirect_to url_for(:controller=>'transactions', :action=>'short')
                    end 
                    else
                        session[:errmsg]="Please Enter Screen Details for Shop #{@session['shortshop']} "
                
                    render :update do |page|
                        page.redirect_to url_for(:controller=>'transaction', :action=>'new')
                    end  
                    end
                    
            end
    rescue Exception=>ex
    puts ex.message
    end
end

#COUNTERCOLLECTION CODE FOR CHECKING WHETHER ALL transactions HAS BEEN FILLED
#FOR THAT SHOP IF YES MAY MOVE TO COUNTER COLLECTION ADDING SCREEN

def checkcounter
          begin
                puts "COUNTER"
                puts @session[:shopname]
                 puts params[:Transaction][:ShopName]
                puts params[:Transaction][:Date]
                #params[:Transaction][:ShopName]=@session['shop']
                
                if (params[:Transaction][:ShopName]=="" or params[:Transaction][:ShopName]==nil) and @session[:shopname]==nil #IF SHOPID NOT SELECTED THEN 
                puts "in ERROR"
                session[:errmsg]="Please select ShopID"
                
                render :update do |page|
                    page.redirect_to url_for(:controller=>'transaction', :action=>'new')
                end 
            else
                puts "in else"
                puts params[:Transaction][:ShopName]
                if(params[:Transaction][:ShopName]=="" and @session[:shopname]!=nil)
                   params[:Transaction][:ShopName]=@session[:shopname]
                   puts "in if@@@@@@@@@@"
                end
        @mcount=Machine.count(["ShopName=?",params[:Transaction][:ShopName]]) #MACHINE COUNT WITH GIVEN SHOPID
        @date=Date.parse(params[:Transaction][:Date])
        puts @date
        @c =Transaction.count(["ShopName=? and Date=? ",params[:Transaction][:ShopName],@date])  #Transaction COUNT WITH GIVEN SHOPID AND DATE
                puts "mcount#{@mcount}"
                puts "Transactioncount#{@c}"
                if(@mcount==@c and @mcount!=0 and @c!=0)
                    puts "total matched hghghg"     
                    @pcount=Previousrecord.count(["ShopName=?",params[:Transaction][:ShopName]])  #PREVIOUSRECORD COUNT WITH SELECTED SHOPID
                    puts @pcount
                    @session['shop']=params[:Transaction][:ShopName]
                    @session['date']=params[:Transaction][:Date]
                
                    if(@pcount==0)
                        @session['shop']=params[:Transaction][:ShopName]
                        @session['date']=params[:Transaction][:Date]
                        render :update do |page|
                            page.redirect_to url_for(:controller=>'previousrecords', :action=>'new')
                        end 
                    else
                        @date=Date.parse(params[:Transaction][:Date])
                        @ccount=Countercollection.count(["ShopName=? and Date=?",params[:Transaction][:ShopName],@date])
                        puts "Counter count"
                        puts @ccount
                       if(@ccount==0)
                            @p=Previousrecord.find_first(["ShopName=?",params[:Transaction][:ShopName]])    
                            puts "values for COLUNTER"
                            puts @p.Xcredit
                            puts @p.Xcash
                            puts @date
                            @session['credit']=@p.Xcredit
                            @session['cash']=@p.Xcash
                            #@session['obal']=@p.Xcredit.to_i+@p.Xcash.to_i
                            @session['obal']=@p.Openingbal
                            @session['date']=@date
                              @session['sname']=params[:Transaction][:ShopName]  
                            render :update do |page|
                                page.redirect_to url_for(:controller=>'countercollections', :action=>'new')
                            end 
                           
                        else
                            @date=Date.parse(params[:Transaction][:Date])
                                 
                                 @counter=Countercollection.find_first(["ShopName=? and Date=?",params[:Transaction][:ShopName],@date])
                                 
                                 puts "CODE FOR EDITING COUNTER COLLECTION"
                                 @session['sname']=@counter.ShopName
                                 @session['obal']=@counter.Openingbal
                                 @session['credit']=@counter.Credit
                                 @session['cash']=@counter.Cash
                                 @session['total1']=@counter.Cash.to_i+@counter.Exp.to_i+@counter.HC.to_i+@counter.Credit.to_i+@counter.Short_Ext.to_i
                                 @session['total2']=@counter.Openingbal.to_i+@counter.KEY1.to_i+@counter.KEY2.to_i+@counter.KEY3.to_i+@counter.KEY4+@counter.Outstanding.to_i
                              
                                    @session['id']=@counter.id
                                 render :update do |page|
                                    page.redirect_to url_for(:controller=>'countercollections', :action=>'edit',:id=>@counter.id)
                            end 
                        end
                    end
                else
                    if(@mcount==0 and @c==0)
                        session[:errmsg]="NO MACHINES MAPPED TO THE SELECTED SHOP"
                        render :update do |page|
                            page.redirect_to url_for(:controller=>'transaction', :action=>'new')
                        end 
                    else
                    
                    render :update do |page|
                        page.redirect_to url_for(:action=>'confirm')
                    end 
                    end
            end
        end 
        rescue Exception=>ex
            puts ex.message 
        end
end
   
   def backtolist
       puts "in list11"
       p @session[:shopname]
       p @session[:Groupid]
       p @session[:MachineNo]
       p @session[:MachineName]
       @session['date']=Date.parse(params[:Transaction][:Date])
       #@date=Date.parse(params[:Transaction][:Date])
       puts @session['date']
    render :update do |page|
	  page.redirect_to url_for(:controller=>'transaction', :action=>'list')
    end  
end


  def redirect_Transactiondata
      @session['msg']="Record saved successfully!"
    render :update do |page|
	  page.redirect_to url_for(:controller=>'transaction', :action=>'list')
    end  
end
 def Transactiondata
    render :update do |page|
	  page.redirect_to url_for( :action=>'new')
    end  
end

def update_group
       @session[:shopid]=params[:ShopID]
        render :update do |page|
            page.replace_html 'shopnamediv', :partial => 'shopname'
        end
    
end 

def update_machine
    begin
    puts "in update_machine"
    @session[:MachineNo]=nil
    puts params[:GroupID]
      @session[:Groupid]=params[:GroupID]
      render :update do |page|
	  page.replace_html 'MachineNodiv', :partial => 'machine'
      page.replace_html 'MachineNamediv', :partial => 'machinename'
       page << "document.getElementById('Transaction_MachineNo').focus();"
      end 
  
    rescue Exception=>ex
        ex.message
    end
end 

def update_machinename
    begin
    p "in update mcname"
    p @session[:shopname]
    @machinename=Machine.find_first(["ShopName=? and MachineNo=?",@session[:shopname],params[:MachineNo]])
    @session[:MachineNo]=params[:MachineNo]
    @session[:MachineName]=@machinename.MachineName
    render :update do |page|
	  page.replace_html 'MachineNamediv', :partial => 'machinename'
       page << "document.getElementById('Transaction_ScreenIN').focus();"
    end
    
    rescue Exception=>ex
        ex.message
    end
end 

 def getGroup
    begin
    @session[:Groupid]=nil
    puts "IN GROUP111111111111111"
    puts params[:ShopName]
    puts @session[:shopname]
    if(params[:ShopName]!="" or params[:ShopName]!=nil)
        #@session[:shopname]=params[:ShopName]
      @session[:shopname]=params[:ShopName]
    end
      puts @session[:shopname]
      render :update do |page|
	  page.replace_html 'KeyIDdiv', :partial => 'group'
      #page.replace_html 'shopnamediv', :partial => 'shopname'
      page.replace_html 'MachineNodiv', :partial => 'machine'
      page.replace_html 'MachineNamediv', :partial => 'machinename'
       page << "document.getElementById('Transaction_GroupID').focus();"
    end
rescue Exception=>exc
     puts exc.message
end
end


def modify
    begin
    @Transaction = Transaction.find_first(["ShopID=? and GroupID=? and MachineNo=? and MachineName=?",session[:shopid],session[:Groupid],session[:machineno],session[:machinename]])
    rescue Exception=>ex
        ex.message
    end
end

def dataTransaction
    @session[:shopid]=""
end

  def index
    list
    render :action => 'list'
  end

  # GETs should be safe (see http://www.w3.org/2001/tag/doc/whenToUseGet.html)
  verify :method => :post, :only => [ :destroy, :create, :update ],
         :redirect_to => { :action => :list }

  def list
     # puts  @session['msg']
    @Transaction_pages, @transactions = paginate :transactions, :per_page => 10
  end

  def show
    @Transaction = Transaction.find(params[:id])
  end

def new
    @transaction = Transaction.new
end



def data
     begin
     @Transaction = Transaction.new(params[:Transaction])
   puts "in save1111"
        if @Transaction.save
        
        flash[:notice] = 'Transaction was successfully created.'
        render :action=>'new'
        #render :update do |page|
        #page.redirect_to url_for(:controller=>'transactions', :action=>'list')
        #end 
        # redirect_to :action => 'list'
        else
        render :action => 'new'
        end
   
    

  rescue Exception=>ex
    ex.message
    
  end  
end

#METHOD WHILE CREATING A NEW Transaction
  def create
   begin
   
   puts "VALUE of date is"
   puts params[:Transaction][:Date]
    #params[:Transaction][:Date]=params[:Transaction_Date]
    
    puts "Value for Screen In"
    puts @session[:shopname]
    puts params[:Transaction][:ScreenIN]
    if params[:Transaction][:ScreenIN]==""
        puts "in ERROR"
        flash[:notice]="Screen IN can't be empty"
        render :action => 'new'
        
    else
       
       puts params[:Transaction][:ShopName]
       puts @session[:shopname]
        if((params[:Transaction][:ShopName]==nil or params[:Transaction][:ShopName]=="") and @session[:shopname]!=nil)
            puts "in if"
            params[:Transaction][:ShopName]=@session[:shopname]
            puts params[:Transaction][:ShopName]
        end
        
        if((params[:Transaction][:GroupID]==nil or params[:Transaction][:GroupID]=="") and @session[:Groupid]!=nil)
            params[:Transaction][:GroupID]=@session[:Groupid]
             
         end
         
         
         if((params[:Transaction][:MachineNo]==nil or params[:Transaction][:MachineNo]=="") and @session[:MachineNo]!=nil)
            params[:Transaction][:MachineNo]=@session[:MachineNo]
             
         end
         if((params[:Transaction][:MachineName]==nil or params[:Transaction][:MachineName]=="") and @session[:MachineName]!=nil)
            params[:Transaction][:MachineName]=@session[:MachineName]
             
         end
         
           @Transaction1=Transaction.find_first(["ShopName=? and GroupID=? and MachineNo=? and MachineName=? and date=?",params[:Transaction][:ShopName],params[:Transaction][:GroupID],params[:Transaction][:MachineNo],params[:Transaction][:MachineName],Date.parse(params[:Transaction][:Date])])
            @Transaction = Transaction.new(params[:Transaction])  
        
        if(@Transaction1!=nil)
        flash[:notice]="<font color=red size=3><b>DUPLICATE Transaction FOR MACHINE No. #{params[:Transaction][:MachineNo]}</b></font> "
        render :action => 'new'
        else
        @cluster=Shop.find_first(["ShopName=?",params[:transaction][:ShopName]])
        params[:Transaction][:ClusterName]=@cluster.ClusterName
        
       @Transaction = Transaction.new(params[:Transaction])
        if @Transaction.save
        flash[:confirm] = '<font color=green size=3><b>Transaction was successfully created.</b></font>'
        @session[:MachineNo]=nil
        @session[:MachineName]=nil
        render :action => 'new'
        #redirect_to :action=>'new'
      
        else
        render :action => 'new'
        end
    end
  end
  rescue Exception=>ex
    ex.message
    
  end
  end

def edit
     @Transaction = Transaction.find(params[:id])
end

  def update
    @Transaction = Transaction.find(params[:id])
    if @Transaction.update_attributes(params[:Transaction])
      flash[:notice] = 'Transaction was successfully updated.'
      #redirect_to :action => 'show', :id => @Transaction
      redirect_to :action=>'list'
    else
      render :action => 'edit'
    end
  end

def destroy
    Transaction.find(params[:id]).destroy
    redirect_to :action => 'list'
end

def canceladd
    render :update do |page|
    page.redirect_to url_for(:controller=>'transaction', :action=>'list')
    end
end

def cancelTransaction
    puts "@@@@@@@@@@@@@@@@@@@@@@@@@"
    puts @session[:shopname]
    puts @session[:Groupid]
    puts @session[:MachineNo]
    puts "#####################"
    render :update do |page|
    page.redirect_to url_for(:controller=>'transaction', :action=>'new')
    end
end

end
