package reservation.dto;

public class SeatDTO {
	String seat_code;
	String row_label;
	int col_num;
	
	public SeatDTO(String seat_code, String row_label, int col_num) {
		super();
		this.seat_code = seat_code;
		this.row_label = row_label;
		this.col_num = col_num;
	}
	public SeatDTO() {

	}
	
	@Override
	public String toString() {
		return "SeatDTO [seat_code=" + seat_code + ", row_label=" + row_label + ", col_num="
				+ col_num + "]";
	}
	
	public String getSeat_code() {
		return seat_code;
	}
	public void setSeat_code(String seat_code) {
		this.seat_code = seat_code;
	}
	public String getRow_label() {
		return row_label;
	}
	public void setRow_label(String row_label) {
		this.row_label = row_label;
	}
	public int getCol_num() {
		return col_num;
	}
	public void setCol_num(int col_num) {
		this.col_num = col_num;
	}
}
