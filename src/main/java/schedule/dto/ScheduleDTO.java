package schedule.dto;

import java.util.Date;

public class ScheduleDTO {
	int schedule_id;
	int movie_id;
	Date Start_time;
	Date end_time;
	public ScheduleDTO(int schedule_id, int movie_id, Date start_time, Date end_time) {
		super();
		this.schedule_id = schedule_id;
		this.movie_id = movie_id;
		Start_time = start_time;
		this.end_time = end_time;
	}
	public ScheduleDTO() {

	}
	public int getSchedule_id() {
		return schedule_id;
	}
	public void setSchedule_id(int schedule_id) {
		this.schedule_id = schedule_id;
	}
	public int getMovie_id() {
		return movie_id;
	}
	public void setMovie_id(int movie_id) {
		this.movie_id = movie_id;
	}
	public Date getStart_time() {
		return Start_time;
	}
	public void setStart_time(Date start_time) {
		Start_time = start_time;
	}
	public Date getEnd_time() {
		return end_time;
	}
	public void setEnd_time(Date end_time) {
		this.end_time = end_time;
	}
	@Override
	public String toString() {
		return "ScheduleDTO [schedule_id=" + schedule_id + ", movie_id=" + movie_id
				+ ", Start_time=" + Start_time + ", end_time=" + end_time + "]";
	}
	
	
}
