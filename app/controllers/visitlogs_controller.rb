class VisitlogsController < ApplicationController
  # GET /visitlogs
  # GET /visitlogs.xml
  def index
    @visitlogs = Visitlog.all

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @visitlogs }
    end
  end

  # GET /visitlogs/1
  # GET /visitlogs/1.xml
  def show
    @visitlog = Visitlog.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @visitlog }
    end
  end

  # GET /visitlogs/new
  # GET /visitlogs/new.xml
  def new
    @visitlog = Visitlog.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @visitlog }
    end
  end

  # GET /visitlogs/1/edit
  def edit
    @visitlog = Visitlog.find(params[:id])
  end

  # POST /visitlogs
  # POST /visitlogs.xml
  def create
    @visitlog = Visitlog.new(params[:visitlog])

    respond_to do |format|
      if @visitlog.save
        flash[:notice] = 'Visitlog was successfully created.'
        format.html { redirect_to(@visitlog) }
        format.xml  { render :xml => @visitlog, :status => :created, :location => @visitlog }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @visitlog.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /visitlogs/1
  # PUT /visitlogs/1.xml
  def update
    @visitlog = Visitlog.find(params[:id])

    respond_to do |format|
      if @visitlog.update_attributes(params[:visitlog])
        flash[:notice] = 'Visitlog was successfully updated.'
        format.html { redirect_to(@visitlog) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @visitlog.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /visitlogs/1
  # DELETE /visitlogs/1.xml
  def destroy
    @visitlog = Visitlog.find(params[:id])
    @visitlog.destroy

    respond_to do |format|
      format.html { redirect_to(visitlogs_url) }
      format.xml  { head :ok }
    end
  end
end
