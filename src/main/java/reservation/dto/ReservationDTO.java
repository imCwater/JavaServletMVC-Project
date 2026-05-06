package reservation.dto;

import java.sql.Timestamp;

public class ReservationDTO {
	int reservation_id;
	int member_id;
	int schedule_id;
	int headcount;
	char status;
	Timestamp reserved_at;
	public ReservationDTO(int reservation_id, int member_id, int schedule_id, int headcount, char status,
			Timestamp reserved_at) {
		super();
		this.reservation_id = reservation_id;
		this.member_id = member_id;
		this.schedule_id = schedule_id;
		this.headcount = headcount;
		this.status = status;
		this.reserved_at = reserved_at;
	}
	public ReservationDTO() {

	}
	@Override
	public String toString() {
		return "ReservationDTO [reservation_id=" + reservation_id + ", member_id=" + member_id + ", schedule_id="
				+ schedule_id + ", headcount=" + headcount + ", status=" + status + ", reserved_at=" + reserved_at
				+ "]";
	}
	
	public int getReservation_id() {
		return reservation_id;
	}
	public void setReservation_id(int reservation_id) {
		this.reservation_id = reservation_id;
	}
	public int getMember_id() {
		return member_id;
	}
	public void setMember_id(int member_id) {
		this.member_id = member_id;
	}
	public int getSchedule_id() {
		return schedule_id;
	}
	public void setSchedule_id(int schedule_id) {
		this.schedule_id = schedule_id;
	}
	public int getHeadcount() {
		return headcount;
	}
	public void setHeadcount(int headcount) {
		this.headcount = headcount;
	}
	public char getStatus() {
		return status;
	}
	public void setStatus(char status) {
		this.status = status;
	}
	public Timestamp getReserved_at() {
		return reserved_at;
	}
	public void setReserved_at(Timestamp reserved_at) {
		this.reserved_at = reserved_at;
	}
	
}
