package schedule.dto;

import java.util.Date;

// SCHEDULE 테이블 한 행을 담는 DTO
// 예매 화면에서 상영 번호, 영화 번호, 시작/종료 시간을 전달할 때 사용한다.
public class ScheduleDTO {
	// SCHEDULE 테이블 기본 컬럼
	int schedule_id;
	int movie_id;
	Date Start_time;
	Date end_time;

	// 전체 값을 받아 DTO를 만들 때 사용하는 생성자
	public ScheduleDTO(int schedule_id, int movie_id, Date start_time, Date end_time) {
		super();
		this.schedule_id = schedule_id;
		this.movie_id = movie_id;
		Start_time = start_time;
		this.end_time = end_time;
	}
	public ScheduleDTO() {

	}

	// schedule_id getter/setter
	public int getSchedule_id() {
		return schedule_id;
	}
	public void setSchedule_id(int schedule_id) {
		this.schedule_id = schedule_id;
	}
	// movie_id getter/setter
	public int getMovie_id() {
		return movie_id;
	}
	public void setMovie_id(int movie_id) {
		this.movie_id = movie_id;
	}
	// start_time getter/setter
	public Date getStart_time() {
		return Start_time;
	}
	public void setStart_time(Date start_time) {
		Start_time = start_time;
	}
	// end_time getter/setter
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
