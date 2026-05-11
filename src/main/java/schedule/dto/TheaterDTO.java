package schedule.dto;

public class TheaterDTO {
	int theaterId;		// 극장 id
	String theaterName;	// 극장명
	String location;	// 지역/주소
	
	public TheaterDTO() {
		
	}

	public TheaterDTO(int theaterId, String theaterName, String location) {
		this.theaterId = theaterId;
		this.theaterName = theaterName;
		this.location = location;
	}

	public int getTheaterId() {
		return theaterId;
	}

	public void setTheaterId(int theaterId) {
		this.theaterId = theaterId;
	}

	public String getTheaterName() {
		return theaterName;
	}

	public void setTheaterName(String theaterName) {
		this.theaterName = theaterName;
	}

	public String getLocation() {
		return location;
	}

	public void setLocation(String location) {
		this.location = location;
	}

	@Override
	public String toString() {
		return "Theater [theaterId=" + theaterId + ", theaterName=" + theaterName + ", location=" + location + "]";
	}
	
	
	
	
	

}
