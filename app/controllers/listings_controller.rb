class ListingsController < ApplicationController
  def index
    render json: Listing.all
    # @listings = Listing.all
    # @listings.each do |listing|
    #   render json: {
    #     listing_id: listing.id,
    #     number_of_rooms: listing.num_rooms,
    #     bookings: listing.bookings,
    #     reservations: listing.reservations,
    #     missions: listing.missions
    #   }
    # Marche pas car on ne peut appeler render json qu'une fois par méthode
    # et là ça l'appelle autant de fois qu'il y a de listing
    # end
  end

  def show
    @listing = Listing.find(params[:id])

    # @listing.missions.delete_all
    # Doesn't work

    # Je crée les missions associées à cet appart

    @listing.bookings.each do |booking|
      # Un nettoyage pour le début de la plage disponible
      Mission.create(
        listing_id: booking.listing.id,
        mission_type: 'first_checkin',
        date: booking.start_date,
        price: "#{booking.listing.num_rooms * 10} €"
      )

      # Un nettoyage pour la fin de la plage disponible
      Mission.create(
        listing_id: booking.listing.id,
        mission_type: 'last_checkout',
        date: booking.end_date,
        price:  "#{booking.listing.num_rooms * 5} €"
      )

      # Les nettoyages liés aux réservations
      booking.reservations.where(start_date: booking.start_date.., end_date: ..booking.end_date).each do |reservation|
        unless reservation.end_date == booking.end_date
          Mission.create(
            listing_id: reservation.listing.id,
            mission_type: 'checkout_checkin',
            date: reservation.end_date,
            price: "#{reservation.listing.num_rooms * 10} €"
          )
        end
      end
    end

    render json: {
      bookings: @listing.bookings,
      reservations: @listing.reservations,
      missions: @listing.missions
    }
  end

  # def new
  # end

  def create
    @listing = Listing.create(listing_params)
    render json: @listing
  end

  # def edit
  # end

  def update
    @listing = Listing.find(params[:id])
    @listing.update_attributes(listing_params)
    render json: @listing
  end

  def destroy
    @listing = Listing.find(params[:id])
    @listing.destroy
    redirect_to listings_path
  end

  private

  def listing_params
    params.require(:listing).permit(:num_rooms)
  end
end
