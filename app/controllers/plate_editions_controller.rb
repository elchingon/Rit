class PlateEditionsController < ApplicationController
  before_filter :authenticate

  def index
    @plate = Plate.find(params[:plate_id])
    @plate_editions = @plate.plate_editions

    respond_to do |format|
      format.html { redirect_to plate_url(@plate) }
      format.js { render :partial => 'plate_editions', :object => @plate_editions }
    end
  end

  def show
    @plate_edition = PlateEdition.find(params[:id])
    @partial = params.fetch(:partial, 'plate_editions/plate_edition')

    respond_to do |format|
      format.html { redirect_to plate_url(@plate_edition.plate_id) }
      format.js  { render :partial => @partial, :locals => { :plate_edition => @plate_edition } }
    end
  end

  def preview
    @plate_edition = PlateEdition.find(params[:id])

    respond_to do |format|
      format.html { redirect_to plate_url(@plate_edition.plate_id) }
      format.js  { render :partial => 'plate_edition_preview', :locals => { :plate_edition => @plate_edition } }
    end
  end

  # NOTE - The create action happens in the plates_controller class so that the URL will look right on errors

  def edit
    @plate_edition = PlateEdition.find(params[:id])
    @partial = params.fetch(:partial, 'plate_editions/remote_edit_form')

    respond_to do |format|
      format.html { redirect_to plate_url(@plate_edition.plate_id) }
      format.js
    end
  end

  def update
    @plate_edition = PlateEdition.find(params[:id])

    respond_to do |format|
      format.html { redirect_to plate_url(@plate_edition.plate.id) }
      new_params = parse_params
      if @plate_edition.update_attributes(new_params)
        @success_url = params.fetch(:success_url, plate_url(@plate_edition.plate))
        @partial = params[:partial]
        flash[:notice] = 'Plate Edition was successfully updated.'
        format.js
      else
        @partial = params.fetch(:error_partial, 'plate_editions/remote_edit_form')
        format.js  { render :action => 'edit' }
          # :partial => @error_form_partial, :locals => { :plate_edition => @plate_edition } }
      end
    end
  end

  def destroy
    @plate_edition = PlateEdition.find(params[:id])
    @plate_edition.destroy

    respond_to do |format|
      format.html { redirect_to(plate_url(@plate_edition.plate_id)) }
      format.xml  { head :ok }
    end
  end
  
  def search
    unless params[:q].blank?
      @query = params[:q]
      @plate_editions = PlateEdition.find(:all, :conditions => "content LIKE '%#{@query}%'")
    else
      redirect_to plates_url
    end
  end


  private
  include ParsesPlateEditionParameters
  
end
