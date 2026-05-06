package reservation.dto;

public class ReservationSeatDTO {
	int reservation_seat_id;
	int reservation_id;
	int schedule_id;
	String seat_code;
	public ReservationSeatDTO(int reservation_seat_id, int reservation_id, int schedule_id, String seat_code) {
		super();
		this.reservation_seat_id = reservation_seat_id;
		this.reservation_id = reservation_id;
		this.schedule_id = schedule_id;
		this.seat_code = seat_code;
	}
	public ReservationSeatDTO() {

	}
	@Override
	public String toString() {
		return "ReservationSeatDTO [reservation_seat_id=" + reservation_seat_id + ", reservation_id=" + reservation_id
				+ ", schedule_id=" + schedule_id + ", seat_code=" + seat_code + "]";
	}
	public int getReservation_seat_id() {
		return reservation_seat_id;
	}
	public void setReservation_seat_id(int reservation_seat_id) {
		this.reservation_seat_id = reservation_seat_id;
	}
	public int getReservation_id() {
		return reservation_id;
	}
	public void setReservation_id(int reservation_id) {
		this.reservation_id = reservation_id;
	}
	public int getSchedule_id() {
		return schedule_id;
	}
	public void setSchedule_id(int schedule_id) {
		this.schedule_id = schedule_id;
	}
	public String getSeat_code() {
		return seat_code;
	}
	public void setSeat_code(String seat_code) {
		this.seat_code = seat_code;
	}
	
}
