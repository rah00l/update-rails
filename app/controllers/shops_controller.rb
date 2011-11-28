class ShopsController < ApplicationController
  layout 'adminlayout'
  require 'ftools'
  require 'chronic'
  #before_filter :login_required
  
  def roundval(val)
    if (val<0)
      if ((val.to_f.to_s.split(".")[1]).to_i<=5)
        return (val).ceil
      else
        return (val).round
      end
    else
      return (val).round
    end
  end
 
  def getfilename
    begin
      files=params[:shop]
      @con=Configuration.find(1)
      @folderpath=@con.FilesFolderPath
      @backupfolder=@con.BackupFolderPath
      basedir = "#{@folderpath}/"
      targetdir="#{@backupfolder}/"
      pw=Dir.pwd()
      Dir.chdir(basedir)
      @files=params[:shop][:FileName]
      i=0
      @files.each { |file|
        @session['filename']=basedir+file
        @session['file']=file
      }
      Dir.chdir(pw)
      render :update do |page|
        page.redirect_to url_for(:controller=>'shops', :action=>'viewdata')
      end
    rescue Exception=>ex
    end
  end

  ############################# UPLOAD ######################################
  def uploaddata
    @con=Configuration.find(1)
    @folderpath=@con.FilesFolderPath
    @backupfolder=@con.BackupFolderPath
    if File.directory?("#{@backupfolder}")
    else
      FileUtils.mkdir_p "#{@backupfolder}"
    end
    basedir = "#{@folderpath}"
    targetdir="#{@backupfolder}"
    pw=Dir.pwd() 
    Dir.chdir(basedir)
    begin
      values=[]
      IO.foreach("#{@session['file']}"){|block| values<<block}
      d=values.to_s.split('COUNTER')
      data=d[0].to_a
      flag="false"
      Dir.chdir(pw)
      for i in 0..(data.length-1)
        @aelement= data[i].to_s.split(',')
        @sname=@aelement[1]
        @gid=@aelement[3]
        @gid=@aelement[3]
        @gid=@aelement[3]
        @mno=@aelement[4]
        @prevdatacount=Machinedata.count(:conditions=>['SHOP_NAME=? and GROUP_ID=? and MACHINE_NO=?',@sname,@gid,@mno],:order => "TRANS_DATE desc" )
        if(@prevdatacount<=0)
          flag="true"
          break
        end
      end
      if(flag=="true")
        render :update do |page|
          page.alert("Enter Previous Days Data for Machine No.#{@mno}")
          page.redirect_to url_for(:action=>'viewdata')
        end
      else
        updatedb
      end
    rescue Exception=>ex
    end
  end

  def updatedb
    begin
      @con=Configuration.find(1)
      @folderpath=@con.FilesFolderPath
      @backupfolder=@con.BackupFolderPath
      basedir = "#{@folderpath}"
      targetdir="#{@backupfolder}"
      pw=Dir.pwd()
      Dir.chdir(basedir)
      values=[]
      IO.foreach("#{@session['file']}"){|block| values<<block}
      d=values.to_s.split('COUNTER')
      data=d[0].to_a
      begin
        Dir.chdir(pw)
        for i in 0..(data.length-1)
          @aelement= data[i].to_s.split(',')
          @clustername=@aelement[0]
          @sname=@aelement[1]
          @gid=@aelement[3]
          @mno=@aelement[4]
          @mc=@aelement[4]
          @trdate=Chronic.parse(@aelement[2]).strftime("%Y-%m-%d")
          @srin=@aelement[5]
          @srout=@aelement[6]
          @mtrin=@aelement[7]
          @mtrout=@aelement[8]
          @mtrshort=@aelement[9]
          @sreason=@aelement[10]
          @currdate=Date.parse("#{@trdate}")
          @oldmdata1=Machinedata.find(:first,:conditions=>['SHOP_NAME=? and GROUP_ID=? and MACHINE_NO=? and CLUSTER_NAME=?',@sname,@gid,@mno,@clustername],:order => "TRANS_DATE desc" )
          @olddate=Date.parse("#{@oldmdata1.TRANS_DATE}")
          @datediff=@currdate-@olddate
          @actualdatediff=@datediff-1
          if @actualdatediff!=0
            for i in 1..@actualdatediff
              @mdata=Machinedata.new()
              @mdata.TRANS_DATE=@olddate+i
              @datenew=@mdata.TRANS_DATE
              @mdata.T_DATE=@mdata.TRANS_DATE.strftime("%d-%b-%Y")
              @mdata.SHOP_NAME=@oldmdata1.SHOP_NAME
              @mdata.GROUP_ID=@oldmdata1.GROUP_ID
              @mdata.MACHINE_NO=@oldmdata1.MACHINE_NO
              @mdata.CLUSTER_NAME=@oldmdata1.CLUSTER_NAME
              @mdata.SRIN=@oldmdata1.PSRINVALUE
              @mdata.SROUT=@oldmdata1.PSROUTVALUE
              @mdata.PSRINVALUE=@mdata.SRIN
              @mdata.PSROUTVALUE=@mdata.SROUT
              @mdata.MTRIN=@oldmdata1.PMTRINVALUE
              @mdata.MTROUT=@oldmdata1.PMTROUTVALUE
              @mdata.PMTRINVALUE=@mdata.MTRIN
              @mdata.PMTROUTVALUE=@mdata.MTROUT
              @mdata.MTRSHORT=0
              @mdetails=Machine.find(:first,:conditions=>['MachineNo=? and GroupID=? and ShopName=?and ClusterName=?',@mdata.MACHINE_NO,@mdata.GROUP_ID,@mdata.SHOP_NAME,@mdata.CLUSTER_NAME])
              @mdata.MACHINE_NAME=@mdetails.MachineName
              @mdata.SCREEN_RATE_IN=@mdetails.SrateIn
              @mdata.SCREEN_RATE_OUT=@mdetails.SrateOut
              @mdata.MTR_RATE_IN=@mdetails.MrateIn
              @mdata.MTE_RATE_OUT=@mdetails.MrateOut
              @mdata.MULTIPLY_BY=@mdetails.Multiplyby
              @oldmdatanew=Machinedata.find(:first,:conditions=>['TRANS_DATE=? and SHOP_NAME=? and GROUP_ID=? and MACHINE_NO=? and CLUSTER_NAME=?',@mdata.TRANS_DATE-1,@sname,@gid,@mno,@clustername])
              oldsrin=@oldmdatanew.PSRINVALUE
              oldsrout=@oldmdatanew.PSROUTVALUE
              oldmtrin=@oldmdatanew.PMTRINVALUE
              oldmtrout=@oldmdatanew.PMTROUTVALUE
              @mdata.TSRIN=(@mdata.SRIN.to_i-oldsrin.to_i)
              @mdata.TSROUT=(@mdata.SROUT.to_i-oldsrout.to_i)
              @mdata.TMTRIN=(@mdata.MTRIN.to_i-oldmtrin.to_i)
              @mdata.TMTROUT=(@mdata.MTROUT.to_i-oldmtrout.to_i)
              @mdata.MTRDIFFIN=((@mdata.MTR_RATE_IN.to_i*@mdata.TMTRIN.to_i)-(@mdata.SCREEN_RATE_IN.to_i*@mdata.TSRIN.to_i))/10
              @mdata.MTRDIFFOUT=((@mdata.MTE_RATE_OUT.to_i*@mdata.TMTROUT.to_i)-(@mdata.SCREEN_RATE_OUT.to_i*@mdata.TSROUT.to_i))/10
              mtrshort = @mdata.MTRSHORT.to_i/@mdata.MULTIPLY_BY.to_i
              @mdata.SRCOLL=(((@mdata.TSRIN.to_i*@mdata.SCREEN_RATE_IN.to_i)-(@mdata.TSROUT.to_i*@mdata.SCREEN_RATE_OUT.to_i))/10)+mtrshort.to_i####
              @mdata.MTRCOLL=(((@mdata.TMTRIN.to_i*@mdata.MTR_RATE_IN.to_i)-(@mdata.TMTROUT.to_i*@mdata.MTE_RATE_OUT.to_i))/10)+mtrshort.to_i
              if @mdata.MTRDIFFIN.to_i==0 and @mdata.MTRDIFFOUT.to_i==0
                @mdata.MTRDIFFWHY='NO'
              elsif @mdata.MTRDIFFIN.to_i==0 and @mdata.MTRDIFFOUT.to_i!=0
                @mdata.MTRDIFFWHY='OUT'
              elsif @mdata.MTRDIFFIN.to_i!=0 and @mdata.MTRDIFFOUT.to_i==0
                @mdata.MTRDIFFWHY='IN'
              else
                @mdata.MTRDIFFWHY='IN/OUT'
              end
              @mdata.SETTING=@oldmdata1.SETTING
              @mdata.LASTSETTING=@oldmdata1.SETTING
              if @mdata.TSRIN<0 or @mdata.TSROUT<0
                @mdata.CALCULATEBY='M'
              else
                @mdata.CALCULATEBY='S'
              end
              @totalmtrshortneg=0
              @totalmtrshortpos=0
              if @mdata.CALCULATEBY!='M'
                @machinevalues=Machinedata.find(:all,:conditions=>['SHOP_NAME=? and GROUP_ID=? and MACHINE_NO=? and CLUSTER_NAME=?',@sname,@gid,@mno,@clustername],:order => "TRANS_DATE desc")
                @machinevalues.each do |item|
                  if(@mdata.SETTING==item.SETTING and item.T_DATE!=nil)
                    if (item.CALCULATEBY!='M')
                      @totalmtrshort=@totalmtrshort.to_i+item.MTRSHORT.to_i
                      if item.MTRSHORT.to_i<0
                        @totalmtrshortneg=@totalmtrshortneg+item.MTRSHORT.to_i
                      else
                        @totalmtrshortpos=@totalmtrshortpos+item.MTRSHORT.to_i
                      end
                    else
                      break
                    end
                  else
                    if ((item.SRIN!=0 and item.PSRINVALUE!=0) or (item.SROUT!=0 and item.PSROUTVALUE!=0))
                      if ((item.SRIN==item.PSRINVALUE )   or (item.SROUT==item.PSROUTVALUE ))
                        if (item.CALCULATEBY!='M')
                          @totalmtrshort=@totalmtrshort.to_i+item.MTRSHORT.to_i
                          if item.MTRSHORT.to_i<0
                            @totalmtrshortneg=@totalmtrshortneg+item.MTRSHORT.to_i
                          else
                            @totalmtrshortpos=@totalmtrshortpos+item.MTRSHORT.to_i
                          end
                        else
                          break
                        end
                      else
                        break
                      end
                    else
                      break
                    end
                  end
                end
              end
              if @srin.to_i!=0
                outval=((@mdata.SROUT.to_f*@mdata.SCREEN_RATE_OUT.to_f)/10).to_i
                if outval!=0
                  outcal=roundval((@mdata.SROUT.to_f*@mdata.SCREEN_RATE_OUT.to_f)/10)
                else
                  outcal=roundval((@mdata.SROUT.to_f*@mdata.SCREEN_RATE_OUT.to_f))
                end
                inval=((@mdata.SRIN.to_f*@mdata.SCREEN_RATE_IN.to_f)/10).to_i
                if inval!=0
                  incal=roundval((@mdata.SRIN.to_f*@mdata.SCREEN_RATE_IN.to_f)/10)
                else
                  incal=roundval((@mdata.SRIN.to_f*@mdata.SCREEN_RATE_IN.to_f))
                end
                begin
                  @cal=roundval(((outcal.to_i-@totalmtrshortneg.to_f)*100)/(incal.to_i+@totalmtrshortpos.to_f))
                rescue Exception=>ex
                  @cal=0
                end
              else
                @cal=0
              end
              @mdata.SRPER=@cal
              if @mdata.SRCOLL<0 or @mdata.MTRCOLL<0
                @mdata.LOSS='Loss'
              else
                @mdata.LOSS='Profit'
              end
              @count=Machinedata.count(:conditions=>['SHOP_NAME=? and GROUP_ID=? and MACHINE_NO=? and CLUSTER_NAME=? and T_DATE!=""',@sname,@gid,@mno,@clustername])
              if @count.to_i>=29
                @values30=Machinedata.find(:all,:conditions=>['SHOP_NAME=? and GROUP_ID=? and MACHINE_NO=? and CLUSTER_NAME=?',@sname,@gid,@mno,@clustername],:order => "TRANS_DATE desc")
                @sumvalue30=0
                @countval=0
                @flag=false
                @values30.each do |item|
                  if @countval.to_i<29
                    if item.CALCULATEBY=='S'
                      @sumvalue30=@sumvalue30.to_i+item.SRCOLL
                    else
                      @sumvalue30=@sumvalue30.to_i+item.MTRCOLL
                    end
                    @flag=true
                    @countval=@countval.to_i+1
                  end
                end
                if @flag==true
                  if @mdata.CALCULATEBY=='S'
                    @sumvalue30=@sumvalue30.to_i+@mdata.SRCOLL.to_i
                  else
                    @sumvalue30=@sumvalue30.to_i+@mdata.MTRCOLL.to_i
                  end
                  @thirtyavg=roundval(@sumvalue30.to_i/30)
                  @mdata.THIRTYDAYSAVG=@thirtyavg
                  @flag=false
                else
                end
              else
              end
              @countval10=1
              if @count.to_i>=9
                @values10=Machinedata.find(:all,:conditions=>['SHOP_NAME=? and GROUP_ID=? and MACHINE_NO=? and CLUSTER_NAME=?',@sname,@gid,@mno,@clustername],:order => "TRANS_DATE desc")
                @sumvalue10=0
                @flag=false
                @values10.each do |item|
                  if @countval10.to_i<=9
                    if item.CALCULATEBY=='S'
                      @sumvalue10=@sumvalue10.to_i+item.SRCOLL.to_i
                    else
                      @sumvalue10=@sumvalue10.to_i+item.MTRCOLL.to_i
                    end
                    @flag=true
                  end
                  @countval10=@countval10.to_i+1
                end
                if @flag==true
                  if @mdata.CALCULATEBY=='S'
                    @sumvalue10=@sumvalue10.to_i+@mdata.SRCOLL.to_i
                  else
                    @sumvalue10=@sumvalue10.to_i+@mdata.MTRCOLL.to_i
                  end
                  @tenavg=roundval(@sumvalue10.to_f/10)
                  @mdata.TENDAYSAVG=@tenavg
                  @flag=false
                else
                end
              else
              end
              @srvalues=0
              @machinevalues=Machinedata.find(:all,:conditions=>['SHOP_NAME=? and GROUP_ID=? and MACHINE_NO=? and CLUSTER_NAME=?',@sname,@gid,@mno,@clustername],:order => "TRANS_DATE desc")
              if @mdata.CALCULATEBY=='S'
                @srvalues=@mdata.SRCOLL
              else
                @srvalues=@mdata.MTRCOLL
              end
              @valcount=2
              @machinevalues.each do |item|
                if(@mdata.SETTING==item.SETTING and item.T_DATE!=nil)
                  @valcount=@valcount+1
                  if item.CALCULATEBY=='S'
                    @srvalues=@srvalues+item.SRCOLL.to_i
                  else
                    @srvalues=@srvalues+item.MTRCOLL.to_i
                  end
                else
                  if ((item.SRIN!=0 and item.PSRINVALUE!=0) or (item.SROUT!=0 and item.PSROUTVALUE!=0))
                    if ((item.SRIN==item.PSRINVALUE )   or (item.SROUT==item.PSROUTVALUE ))
                      @valcount=@valcount+1
                      if item.CALCULATEBY=='S'
                        @srvalues=@srvalues+item.SRCOLL.to_i
                      else
                        @srvalues=@srvalues+item.MTRCOLL.to_i
                      end
                    else
                      break
                    end
                  else
                    break
                  end
                end
              end
              if @valcount<=2
                @valcount=1
              else
                @valcount=@valcount-1
              end
                
              begin
                @mdata.SRAVG=roundval(@srvalues.to_f/(@valcount.to_i))
              rescue Exception=>ex
                @mdata.SRAVG=@srvalues
              end
              @totalmtrshortmperpos=0
              @totalmtrshortmperneg=0
              @sinval=0
              @sroutval=0
              @countvalues=0
              @machinevalues=Machinedata.find(:all,:conditions=>['SHOP_NAME=? and GROUP_ID=? and MACHINE_NO=? and CLUSTER_NAME=?',@sname,@gid,@mno,@clustername],:order => "TRANS_DATE desc")
              @machinevalues.each do |item|
                if(@mdata.SETTING==item.SETTING)
                  @countvalues=@countvalues+1
                  if item.CALCULATEBY=='S'
                    @sinval=@sinval.to_f + item.TSRIN.to_f
                    @sroutval=@sroutval.to_f + item.TSROUT.to_f
                  else
                    @sinval=@sinval.to_f + item.TMTRIN.to_f
                    @sroutval=@sroutval.to_f + item.TMTROUT.to_f
                  end
                  if item.MTRSHORT.to_i<0
                    @totalmtrshortmperneg=@totalmtrshortmperneg.to_i+item.MTRSHORT.to_i
                  else
                    @totalmtrshortmperpos=@totalmtrshortmperpos.to_i+item.MTRSHORT.to_i
                  end
                else
                  if ((item.SRIN!=0 and item.PSRINVALUE!=0) or (item.SROUT!=0 and item.PSROUTVALUE!=0))
                    if ((item.SRIN==item.PSRINVALUE )   or (item.SROUT==item.PSROUTVALUE ))
                      if item.CALCULATEBY=='S'
                        @sinval=@sinval.to_f + item.TSRIN.to_f
                        @sroutval=@sroutval.to_f + item.TSROUT.to_f
                      else
                        @sinval=@sinval.to_f + item.TMTRIN.to_f
                        @sroutval=@sroutval.to_f + item.TMTROUT.to_f
                      end
                      if item.MTRSHORT.to_i<0
                        @totalmtrshortmperneg=@totalmtrshortmperneg.to_i+item.MTRSHORT.to_i
                      else
                        @totalmtrshortmperpos=@totalmtrshortmperpos.to_i+item.MTRSHORT.to_i
                      end
                    else
                      break
                    end
                  else
                    break
                  end
                end
              end
              if @sinval.to_i!=0
                @cal1=roundval((roundval((@sroutval.to_f*@mdata.MTE_RATE_OUT.to_f)/10)-@totalmtrshortmperneg.to_f)*100/(roundval((@sinval.to_f*@mdata.MTR_RATE_IN.to_f)/10)+@totalmtrshortmperpos.to_f))
              else
                @cal1=0
              end
              @totalmtrshortmperpos=0
              @totalmtrshortmperneg=0
              @sinval=0
              @sroutval=0
              begin
                @mdata.MTRPER=@cal1
              rescue
              end
              begin
                digitn=@mno.to_s.gsub(/\D/,'')
                charn=@mno.to_s.gsub(/\d/,'')
              rescue Exception=>ex
              end
              @mdata.digitno=digitn
              @mdata.charno=charn
              @mdata.save
            end
          end
          @dataexist=Machinedata.find(:first,:conditions=>['TRANS_DATE=? and SHOP_NAME=? and GROUP_ID=? and MACHINE_NO=? and CLUSTER_NAME=?',@trdate,@sname,@gid,@mno,@clustername])
          if @dataexist!=nil
          else
            a=savemdata(@sname,@gid,@mno,@trdate,@srin,@srout,@mtrin,@mtrout,@mtrshort,@sreason,@clustername)
            if(a==false)
              break
            end
                    
          end
        end
      rescue Exception=>ex
        #puts ex.message()
        @rescueflag=true
      end
      replicatecounterdata(d[1].to_s)
      if(a==true)
        @con=Configuration.find(1)
        @folderpath=@con.FilesFolderPath
        @backupfolder=@con.BackupFolderPath
        basedir = "#{@folderpath}/"
        targetdir="#{@backupfolder}/"
        pw=Dir.pwd()
        Dir.chdir(basedir)
        @files=@session['file']
        i=0
        begin
          @files.each { |file|
            if File.file?(basedir + file)      
              File.move(basedir + file, targetdir + file)
            end
          }
          Dir.chdir(pw)
        rescue Exception=>ex
          Dir.chdir(pw)
        end
        Group.find(:all,:select=>'GroupID',:conditions=>["ClusterName=? and ShopName=?",@clustername,@sname]).each do |key|
          #Group.find_by_ClusterName_and_ShopName(@clustername,@sname).each do |key|
          machine_data = Machinedata.find(:all,
            :conditions=> ["Cluster_Name=? and Shop_Name=? and TRANS_DATE=? and GROUP_ID=?",
              @clustername,@sname,@trdate,key.GroupID])
          @tot_short_extra=0
          machine_data.each do |data|
            if data.CALCULATEBY.eql?('S')
              short_extra = (((((data.TSRIN.to_f*data.SCREEN_RATE_IN.to_f)-(data.TSROUT.to_f*data.SCREEN_RATE_OUT.to_f))/10)*data.MULTIPLY_BY)+data.MTRSHORT.to_f).round
              @tot_short_extra = @tot_short_extra + short_extra
            else
              short_extra =(((((data.TMTRIN.to_f*data.MTR_RATE_IN.to_f)-(data.TMTROUT.to_f*data.MTE_RATE_OUT.to_f))/10)*data.MULTIPLY_BY)+data.MTRSHORT.to_f).round
              @tot_short_extra = @tot_short_extra + short_extra
            end
          end
          keys = Counterdata.find(:first,:conditions=>["ClusterName=? and ShopName=? and DATE=?",
              @clustername,@sname,@trdate])
          if keys!= nil
            if key.GroupID.eql?('KEY 1')
              keyval=keys.KEY1.to_i
            end
            if key.GroupID=='KEY 2'
              keyval=keys.KEY2.to_i
            end
            if key.GroupID=='KEY 3'
              keyval=@keys.KEY3.to_i
            end
            if key.GroupID=='KEY 4'
              keyval=@keys.KEY4.to_i
            end
          end
          short_extra = (keyval.to_i - @tot_short_extra.to_i)
          ShortExtra.find_or_create_by_date_and_cluster_name_and_shop_name_and_group_id_and_short_extra("#{@trdate}","#{@clustername}","#{@sname}","#{key.GroupID}",short_extra)
        end
        render :update do |page|
          page << "document.getElementById('aux_div').style.visibility = 'visible'"
          page.alert("DATA UPLOADED SUCCESSFULLY !")
          page.redirect_to url_for(:controller=>'shops', :action=>'receiveddata')
        end
      else
        render :update do |page|
          page << "document.getElementById('aux_div').style.visibility = 'visible'"
          page.alert("PROBLEM IN FILE UPLOADED!")
          d=Dir.pwd()
          if File.directory?("C:\ErrorLogs")
            f="C:/ErrorLogs"
            Dir.chdir(f)
            fp=File.new("Error.log","a")
            fp.write(Time.now.to_s+"-"+a.to_s)
            fp.write("\n")
            fp.close()
            Dir.chdir(d)
          else
            e="C:/"
            Dir.chdir(e)
            FileUtils.mkdir_p 'ErrorLogs'
            f="C:/ErrorLogs"
            Dir.chdir(f)
            fp=File.new("Error.log","a")
            fp.write(Time.now.to_s+"-"+a.to_s)
            fp.write("\n")
            fp.close()
            Dir.chdir(d)
          end
          page.redirect_to url_for(:controller=>'shops', :action=>'viewdata')
        end
      end
    rescue Exception=>ex
    end
  end

  def replicatecounterdata(cdata)
    begin
      counterdata=cdata.to_a
      for i in 0..(counterdata.length-1)
        a= counterdata[i].to_s.split(',')
      end
      @oldcdata=Counterdata.find(:first,:conditions=>['ClusterName=? and ShopName=?',a[0],a[1]],:order => "Date desc" )
      if @oldcdata==nil
        @counterolddata=Counterdata.find(:first,:conditions=>['ClusterName=? and ShopName=? and Date=?',a[0],a[1],a[2]])
        if @counterolddata==nil
          @counter=Counterdata.new
          @counter.ClusterName=a[0]
          @counter.ShopName=a[1]
          @counter.Date=a[2]
          @counter.Cash=a[3]
          @counter.Exp=a[4]
          @counter.HC=a[5]
          @counter.Credit=a[6]
          @counter.Short_Ext=a[7]
          @counter.Openingbal=a[8]
          @counter.KEY1=a[9]
          @counter.KEY2=a[10]
          @counter.KEY3=a[11]
          @counter.KEY4=a[12]
          @counter.Outstanding=a[13]
          @counter.status=a[14]
          @counter.Total=a[15]
          @counter.save
        end
      else
        @olddate=Date.parse("#{@oldcdata.Date}")
        @datediff=@currdate-@olddate
        @actualdatediff=@datediff-1
        if @actualdatediff!=0
          for i in 1..@actualdatediff
            @counter=Counterdata.new
            @counter.ClusterName=@oldcdata.ClusterName
            @counter.ShopName=@oldcdata.ShopName
            @counter.Date=@olddate+i
            @counter.Cash=@oldcdata.Cash
            @counter.Credit=@oldcdata.Credit
            @counter.Openingbal=@counter.Cash.to_i+@counter.Credit.to_i
            @counter.save
          end
        end
      end
      @countval=Counterdata.count(:conditions=>['ClusterName=? and ShopName=? and Date=?',a[0],a[1],a[2]])
      if @countval.to_i==0
        @counter=Counterdata.new
        @counter.ClusterName=a[0]
        @counter.ShopName=a[1]
        @counter.Date=a[2]
        @counter.Cash=a[3]
        @counter.Exp=a[4]
        @counter.HC=a[5]
        @counter.Credit=a[6]
        @counter.Short_Ext=a[7]
        @counter.Openingbal=a[8]
        @counter.KEY1=a[9]
        @counter.KEY2=a[10]
        @counter.KEY3=a[11]
        @counter.KEY4=a[12]
        @counter.Outstanding=a[13]
        @counter.status=a[14]
        @counter.Total=a[15]
        @counter.save
      else
      end
    rescue Exception=>ex
    end
  end

  def savemdata(sname,gid,mno,trdate,srin,srout,mtrin,mtrout,mtrshort,sreason,cname)
    begin
      @mdata=Machinedata.new()
      @mdata.TRANS_DATE=Chronic.parse(trdate).strftime("%Y-%m-%d")
      @mdata.T_DATE=@mdata.TRANS_DATE.strftime("%d-%b-%Y")
      @mdata.CLUSTER_NAME=cname
      @mdata.SHOP_NAME=sname
      @mdata.GROUP_ID=gid
      @mdata.MACHINE_NO=mno
      begin
        digitn=mno.to_s.gsub(/\D/,'')
        charn=mno.to_s.gsub(/\d/,'')
      rescue Exception=>ex
      end
      @mdata.digitno=digitn
      @mdata.charno=charn
      @mdata.SRIN=srin
      @mdata.SROUT=srout
      @mdata.PSRINVALUE=srin
      @mdata.PSROUTVALUE=srout
      @mdata.MTRIN=mtrin
      @mdata.MTROUT=mtrout
      @mdata.PMTRINVALUE=mtrin
      @mdata.PMTROUTVALUE=mtrout
      @mdata.MTRSHORT=mtrshort
      @mdata.SHORTREASON=sreason
      @mdetails=Machine.find(:first,:conditions=>['MachineNo=? and GroupID=? and ShopName=? and ClusterName=?',mno,gid,sname,cname])
      @mdata.MACHINE_NAME=@mdetails.MachineName
      @mdata.SCREEN_RATE_IN=@mdetails.SrateIn
      @mdata.SCREEN_RATE_OUT=@mdetails.SrateOut
      @mdata.MTR_RATE_IN=@mdetails.MrateIn
      @mdata.MTE_RATE_OUT=@mdetails.MrateOut
      @mdata.MULTIPLY_BY=@mdetails.Multiplyby
      @olddate1=Date.parse("#{trdate}")-1
      @oldmdata=Machinedata.find(:first,:conditions=>['TRANS_DATE=? and SHOP_NAME=? and GROUP_ID=? and MACHINE_NO=? and CLUSTER_NAME=?',@olddate1,sname,gid,mno,cname])
      oldsrin=@oldmdata.PSRINVALUE
      oldsrout=@oldmdata.PSROUTVALUE
      oldmtrin=@oldmdata.PMTRINVALUE
      oldmtrout=@oldmdata.PMTROUTVALUE
      @mdata.TSRIN=(srin.to_i-oldsrin.to_i)#.abs#No absolute value required
      @mdata.TSROUT=(srout.to_i-oldsrout.to_i)#.abs#No absolute value required
      @mdata.TMTRIN=(mtrin.to_i-oldmtrin.to_i)#.abs No absolute required
      @mdata.TMTROUT=(mtrout.to_i-oldmtrout.to_i)#.abs No absolute req.
      @mdata.MTRDIFFIN=((@mdata.MTR_RATE_IN.to_i*@mdata.TMTRIN.to_i)-(@mdata.SCREEN_RATE_IN.to_i*@mdata.TSRIN.to_i))/10#.abs Not required display divide by 10
      @mdata.MTRDIFFOUT=((@mdata.MTE_RATE_OUT.to_i*@mdata.TMTROUT.to_i)-(@mdata.SCREEN_RATE_OUT.to_i*@mdata.TSROUT.to_i))/10#.abs Not requ
      @mdata.SETTING=@oldmdata.SETTING
      @mdata.LASTSETTING=@oldmdata.SETTING
      mtrshort_after_mul_by = mtrshort.to_i/@mdata.MULTIPLY_BY.to_i
      @mdata.SRCOLL=(((@mdata.TSRIN.to_i*@mdata.SCREEN_RATE_IN.to_i)-(@mdata.TSROUT.to_i*@mdata.SCREEN_RATE_OUT.to_i))/10)+mtrshort_after_mul_by.to_i####
      @mdata.MTRCOLL=(((@mdata.TMTRIN.to_i*@mdata.MTR_RATE_IN.to_i)-(@mdata.TMTROUT.to_i*@mdata.MTE_RATE_OUT.to_i))/10)+mtrshort_after_mul_by.to_i
      if @mdata.MTRDIFFIN.to_i==0 and @mdata.MTRDIFFOUT.to_i==0
        @mdata.MTRDIFFWHY='NO'
      elsif @mdata.MTRDIFFIN.to_i==0 and @mdata.MTRDIFFOUT.to_i!=0
        @mdata.MTRDIFFWHY='OUT'
      elsif @mdata.MTRDIFFIN.to_i!=0 and @mdata.MTRDIFFOUT.to_i==0
        @mdata.MTRDIFFWHY='IN'
      else
        @mdata.MTRDIFFWHY='IN/OUT'
      end
      if @mdata.TSRIN<0 or @mdata.TSROUT<0
        @mdata.CALCULATEBY='M'
      else
        @mdata.CALCULATEBY='S'
      end
      if mtrshort.to_i<0
        @totalmtrshortpos=0
        @totalmtrshortneg=mtrshort.to_i
      else
        @totalmtrshortpos=mtrshort.to_i
        @totalmtrshortneg=0
      end
      if @mdata.CALCULATEBY!='M'
        @machinevalues=Machinedata.find(:all,:conditions=>['SHOP_NAME=? and GROUP_ID=? and MACHINE_NO=? and CLUSTER_NAME=?',sname,gid,mno,cname],:order => "TRANS_DATE desc")
        @machinevalues.each do |item|
          if(@mdata.SETTING==item.SETTING and item.T_DATE!=nil)
            if (item.CALCULATEBY!='M')
              @totalmtrshort=@totalmtrshort.to_i+item.MTRSHORT.to_i
              if item.MTRSHORT.to_i<0
                @totalmtrshortneg=@totalmtrshortneg+item.MTRSHORT.to_i
              else
                @totalmtrshortpos=@totalmtrshortpos+item.MTRSHORT.to_i
              end
            else
              break
            end
          else
            if ((item.SRIN!=0 and item.PSRINVALUE!=0) or (item.SROUT!=0 and item.PSROUTVALUE!=0))
              if ((item.SRIN==item.PSRINVALUE )   or (item.SROUT==item.PSROUTVALUE ))
                if (item.CALCULATEBY!='M')
                  @totalmtrshort=@totalmtrshort.to_i+item.MTRSHORT.to_i
                  if item.MTRSHORT.to_i<0
                    @totalmtrshortneg=@totalmtrshortneg+item.MTRSHORT.to_i
                  else
                    @totalmtrshortpos=@totalmtrshortpos+item.MTRSHORT.to_i
                  end
                else
                  break
                end
              else
                break
              end
            else
              break
            end
          end
        end
      end
      if srin.to_i!=0
        outval=((@mdata.SROUT.to_f*@mdata.SCREEN_RATE_OUT.to_f)/10).to_i
        if outval!=0
          outcal=roundval((@mdata.SROUT.to_f*@mdata.SCREEN_RATE_OUT.to_f)/10)
        else
          outcal=roundval((@mdata.SROUT.to_f*@mdata.SCREEN_RATE_OUT.to_f))
        end
        inval=((@mdata.SRIN.to_f*@mdata.SCREEN_RATE_IN.to_f)/10).to_i
        if inval!=0
          incal=roundval((@mdata.SRIN.to_f*@mdata.SCREEN_RATE_IN.to_f)/10)
        else
          incal=roundval((@mdata.SRIN.to_f*@mdata.SCREEN_RATE_IN.to_f))
        end
                          
        begin
          @cal=roundval(((outcal.to_i-@totalmtrshortneg.to_f)*100)/(incal.to_i+@totalmtrshortpos.to_f))
        rescue Exception=>ex
          @cal=0
        end
      else
        @cal=0
      end
      @mdata.SRPER=@cal
      if @mdata.SRCOLL<0 or @mdata.MTRCOLL<0
        @mdata.LOSS='Loss'
      else
        @mdata.LOSS='Profit'
      end
      @count=Machinedata.count(:conditions=>['SHOP_NAME=? and GROUP_ID=? and MACHINE_NO=? and CLUSTER_NAME=? and T_DATE!=""',sname,gid,mno,cname])
      if @count.to_i>=29
        @values30=Machinedata.find(:all,:conditions=>['SHOP_NAME=? and GROUP_ID=? and MACHINE_NO=? and CLUSTER_NAME=?',@sname,@gid,@mno,@clustername],:order => "TRANS_DATE desc")
        @sumvalue30=0
        @countval=0
        @flag=false
        @values30.each do |item|
          if @countval.to_i<29
            if item.CALCULATEBY=='S'
              @sumvalue30=@sumvalue30.to_i+item.SRCOLL
            else
              @sumvalue30=@sumvalue30.to_i+item.MTRCOLL
            end
            @flag=true
            @countval=@countval.to_i+1
          end
        end
        if @flag==true
          if @mdata.CALCULATEBY=='S'
            @sumvalue30=@sumvalue30.to_i+@mdata.SRCOLL.to_i
          else
            @sumvalue30=@sumvalue30.to_i+@mdata.MTRCOLL.to_i
          end
          @thirtyavg=roundval(@sumvalue30.to_f/30)
          @mdata.THIRTYDAYSAVG=@thirtyavg
          @flag=false
        else
        end
      else
      end
      @countval10=1
      if @count.to_i>=9
        @values10=Machinedata.find(:all,:conditions=>['SHOP_NAME=? and GROUP_ID=? and MACHINE_NO=? and CLUSTER_NAME=?',sname,gid,mno,cname],:order => "TRANS_DATE desc")
        @sumvalue10=0
        @flag=false
        @values10.each do |item|
          if @countval10.to_i<=9
            if item.CALCULATEBY=='S'
              @sumvalue10=@sumvalue10.to_i+item.SRCOLL.to_i
            else
              @sumvalue10=@sumvalue10.to_i+item.MTRCOLL.to_i
            end
            @flag=true
          end
          @countval10=@countval10.to_i+1
        end
        if @flag==true
          if @mdata.CALCULATEBY=='S'
            @sumvalue10=@sumvalue10.to_i+@mdata.SRCOLL.to_i
          else
            @sumvalue10=@sumvalue10.to_i+@mdata.MTRCOLL.to_i
          end
          @tenavg=roundval(@sumvalue10.to_f/10)
          @mdata.TENDAYSAVG=@tenavg
          @flag=false
        else
        end
      else
      end
      @machinevalues=Machinedata.find(:all,:conditions=>['SHOP_NAME=? and GROUP_ID=? and MACHINE_NO=? and CLUSTER_NAME=? ',sname,gid,mno,cname],:order => "TRANS_DATE desc")
      @srvalues=0
      if @mdata.CALCULATEBY=='S'
        @srvalues=@mdata.SRCOLL
      else
        @srvalues=@mdata.MTRCOLL
      end
      @valcount=2
      @machinevalues.each do |item|
        if(@mdata.SETTING==item.SETTING and item.T_DATE!=nil)
          @valcount=@valcount+1
          if item.CALCULATEBY=='S'
            @srvalues=@srvalues+item.SRCOLL.to_i
          else
            @srvalues=@srvalues+item.MTRCOLL.to_i
          end
        else
          if ((item.SRIN!=0 and item.PSRINVALUE!=0) or (item.SROUT!=0 and item.PSROUTVALUE!=0))
            if ((item.SRIN==item.PSRINVALUE )   or (item.SROUT==item.PSROUTVALUE ))
              @valcount=@valcount+1
              if item.CALCULATEBY=='S'
                @srvalues=@srvalues+item.SRCOLL.to_i
              else
                @srvalues=@srvalues+item.MTRCOLL.to_i
              end
            else
              break
            end
          else
            break
          end
        end
      end
      begin
        if @valcount.to_i<=2
          @valcount=1
        else
          @valcount=@valcount.to_i-1
        end
        @mdata.SRAVG=roundval(@srvalues.to_f/(@valcount.to_i))
      rescue Exception=>ex
        @mdata.SRAVG=@srvalues
      end
      @sinval=0
      @sroutval=0
      @totalmtrshortmperneg=0
      @totalmtrshortmperpos=0
      @machinevalues=Machinedata.find(:all,:conditions=>['SHOP_NAME=? and GROUP_ID=? and MACHINE_NO=? and CLUSTER_NAME=?',sname,gid,mno,cname],:order => "TRANS_DATE desc")
      if @mdata.CALCULATEBY=='S'
        @sinval=@mdata.TSRIN.to_i
        @sroutval=@mdata.TSROUT.to_i
      else
        @sinval=@mdata.TMTRIN.to_i
        @sroutval=@mdata.TMTROUT.to_i
      end
      if mtrshort.to_i<0
        @totalmtrshortmperneg=mtrshort.to_i
        @totalmtrshortmperpos=0
      else
        @totalmtrshortmperneg=0
        @totalmtrshortmperpos=mtrshort.to_i
      end
      @machinevalues.each do |item|
        if(@mdata.SETTING==item.SETTING)
          if item.CALCULATEBY=='S'
            @sinval=@sinval.to_f + item.TSRIN.to_f
            @sroutval=@sroutval.to_f + item.TSROUT.to_f
          else
            @sinval=@sinval.to_f + item.TMTRIN.to_f
            @sroutval=@sroutval.to_f + item.TMTROUT.to_f
          end
          if item.MTRSHORT.to_i<0
            @totalmtrshortmperneg=@totalmtrshortmperneg.to_i+item.MTRSHORT.to_i
          else
            @totalmtrshortmperpos=@totalmtrshortmperpos.to_i+item.MTRSHORT.to_i
          end
        else
          if ((item.SRIN!=0 and item.PSRINVALUE!=0) or (item.SROUT!=0 and item.PSROUTVALUE!=0))
            if ((item.SRIN==item.PSRINVALUE )   or (item.SROUT==item.PSROUTVALUE ))
              if item.CALCULATEBY=='S'
                @sinval=@sinval.to_f + item.TSRIN.to_f
                @sroutval=@sroutval.to_f + item.TSROUT.to_f
              else
                @sinval=@sinval.to_f + item.TMTRIN.to_f
                @sroutval=@sroutval.to_f + item.TMTROUT.to_f
              end
              if item.MTRSHORT.to_i<0
                @totalmtrshortmperneg=@totalmtrshortmperneg.to_i+item.MTRSHORT.to_i
              else
                @totalmtrshortmperpos=@totalmtrshortmperpos.to_i+item.MTRSHORT.to_i
              end
            else
              break
            end
          else
            break
          end
        end
      end
      if @sinval.to_i!=0
        @cal1=roundval((roundval((@sroutval.to_f*@mdata.MTE_RATE_OUT.to_f)/10)-@totalmtrshortmperneg.to_f)*100/(roundval((@sinval.to_f*@mdata.MTR_RATE_IN.to_f)/10)+@totalmtrshortmperpos.to_f))
      else
        @cal1=0
      end
      begin
        @mdata.MTRPER=@cal1
      rescue
      end
      @mdata.save
      return true
    rescue Exception=>ex
      return ex.message
    end
  end

  def search
      @Cluster_Name=Cluster.find(:all,:order => "ClusterName")
  end

  def getCluster
      if(params[:ClusterName]!="" or params[:ClusterName]!=nil)
        session['cluster']=params[:ClusterName]
      end
      render :update do |page|
        page << "document.getElementById('shop_ShopName').focus();"
      end
  end

  def index
    @shops = Shop.find(:all,:conditions => ["ClusterName=?",params[:shop][:ClusterName]],:order => "ShopName")
    respond_to do|format|
			format.html
      format.js {render :file => 'shops/index' }
    end
  end

  def list
    @shop_pages, @shops = paginate :shops, :per_page => 10
  end

#  def show
#    @shop = Shop.find(params[:id])
#  end

  def new
    @shop = Shop.new
     @shop_names = Cluster.find(:all,:order => "ClusterName")
    
  end

  def create
    @shop_names = Cluster.find(:all,:order => "ClusterName")
    @cluster=Cluster.find(:all,:conditions=>["ClusterName<>?",session['cluster']],:order => "ClusterName")
    @shop = Shop.new(params[:shop])
    respond_to do |format|
    if @shop.save
      @previousrecord = Previousrecord.new
      @previousrecord.Date=Date.today
      @previousrecord.ShopName=params[:shop][:ShopName]
      @previousrecord.Openingbal=params[:shop][:OpeningBal]
      @previousrecord.Xcash=@shop.Cash
      @previousrecord.Xcredit=@shop.Credit
      @previousrecord.save
      flash[:notice] =  '<font color=green size=3><b>SHOP WAS SUCCESSFULLY CREATED.</b></font>'
      format.html { render :action => "new" }
    else
      format.html { render :action => "new" }
    end
    end
  end

  def edit
    @shop = Shop.find(params[:id])
  end

  def update
    @shop = Shop.find(params[:id])
    if @shop.update_attributes(params[:shop])
      @p=Previousrecord.find_first(["ShopName=?",params[:shop][:ShopName]])
      if(@p!=nil)
        @p.Date=Date.today
        @p.Xcash=@shop.Cash
        @p.Xcredit=@shop.Credit
        @p.Openingbal=params[:shop][:OpeningBal]
        @p.save
      end
      flash[:notice] =  '<font color=green size=3><b>SHOP WAS SUCCESSFULLY UPDATED.</b></font>'
      redirect_to :action => 'list', :id => @shop
    else
      render :action => 'edit'
    end
  end

  def destroy
    Shop.find(params[:id]).destroy
    redirect_to :action => 'list'
  end
  def canceladd
    render :update do |page|
      page.redirect_to url_for(:controller=>'shops', :action=>'search')
    end
  end

  #METHOD WHILE CREATING A NEW clientdata
  def createpreviousdata
    if params[:clientdata][:ScreenIN]==""
      flash[:notice]="Screen IN can't be empty"
      render :action => 'previousdata'
    else
      if((params[:clientdata][:ShopName]==nil or params[:clientdata][:ShopName]=="") and @session[:shopname]!=nil)
        params[:clientdata][:ShopName]=@session[:shopname]
      end
      if((params[:clientdata][:GroupID]==nil or params[:clientdata][:GroupID]=="") and @session[:Groupid]!=nil)
        params[:clientdata][:GroupID]=@session[:Groupid]
      end
      if((params[:clientdata][:MachineNo]==nil or params[:clientdata][:MachineNo]=="") and @session[:MachineNo]!=nil)
        params[:clientdata][:MachineNo]=@session[:MachineNo]
      end
      if((params[:clientdata][:MachineName]==nil or params[:clientdata][:MachineName]=="") and @session[:MachineName]!=nil)
        params[:clientdata][:MachineName]=@session[:MachineName]
             
      end
      @date=Date.parse(params[:clientdata][:Date])
      @duprecord=Machinedata.find_first(["Shop_Name=? and Group_ID=? and Machine_No=? and Machine_Name=?  and trans_date=?",params[:clientdata][:ShopName],params[:clientdata][:GroupID],params[:clientdata][:MachineNo],params[:clientdata][:MachineName],@date])
      if(@duprecord!=nil)
        flash[:notice]="<font color=red size=4><b>DUPLICATE ENTRY FOR MACHINE No. #{params[:clientdata][:MachineNo]}</b></font> "
        render :action => 'previousdata'
      else
        @cluster=Shop.find_first(["ShopName=?",params[:clientdata][:ShopName]])
        params[:clientdata][:ClusterName]=@cluster.ClusterName
        @data=Machinedata.new
        @data.SHOP_NAME=params[:clientdata][:ShopName]
        @data.GROUP_ID=params[:clientdata][:GroupID]
        @data.TRANS_DATE=@date
        @data.MACHINE_NO=params[:clientdata][:MachineNo]
        @data.MACHINE_NAME=params[:clientdata][:MachineName]
        @data.SRIN=params[:clientdata][:ScreenIN]
        @data.SROUT=params[:clientdata][:ScreenOUT]
        @data.MTRIN=params[:clientdata][:MeterIN]
        @data.MTROUT=params[:clientdata][:MeterOUT]
        @data.SETTING="A"
        @data.LASTSETTING=@date
        if @data.save
          flash[:confirm] = '<font color=green size=4><b>ENTRY WAS SUCCESSFULLY CREATED.</b></font>'
          @session[:MachineNo]=nil
          @session[:MachineName]=nil
          render :action => 'previousdata'
        else
          render :action => 'previousdata'
        end
      end
    end
  end
end