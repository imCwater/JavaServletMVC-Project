package schedule.dto;

import java.sql.Timestamp;
import java.time.LocalDateTime;

public class ScheduleDTO {

	private static final int DEFAULT_PRICE = 12000;

	private int scheduleId;
	private int movieId;
	private int screenId;
	private LocalDateTime startTime;
	private LocalDateTime endTime;
	private int price;

	public ScheduleDTO() {
		this.price = DEFAULT_PRICE;
	}

	public ScheduleDTO(int scheduleId, int movieId, int screenId, LocalDateTime startTime, LocalDateTime endTime) {

		this.scheduleId = scheduleId;
		this.movieId = movieId;
		this.screenId = screenId;
		this.startTime = startTime;
		this.endTime = endTime;
		this.price = DEFAULT_PRICE;
	}

	public ScheduleDTO(int scheduleId, int movieId, int screenId, LocalDateTime startTime, LocalDateTime endTime,
			int price) {

		this.scheduleId = scheduleId;
		this.movieId = movieId;
		this.screenId = screenId;
		this.startTime = startTime;
		this.endTime = endTime;
		this.price = price;
	}

	public int getScheduleId() {
		return scheduleId;
	}

	public int getSchedule_id() {
		return scheduleId;
	}

	public void setScheduleId(int scheduleId) {
		this.scheduleId = scheduleId;
	}

	public int getMovieId() {
		return movieId;
	}

	public int getMovie_id() {
		return movieId;
	}

	public void setMovieId(int movieId) {
		this.movieId = movieId;
	}

	public int getScreenId() {
		return screenId;
	}

	public int getScreen_id() {
		return screenId;
	}

	public void setScreenId(int screenId) {
		this.screenId = screenId;
	}

	public LocalDateTime getStartTime() {
		return startTime;
	}

	public Timestamp getStart_time() {
		return startTime == null ? null : Timestamp.valueOf(startTime);
	}

	public void setStartTime(LocalDateTime startTime) {
		this.startTime = startTime;
	}

	public LocalDateTime getEndTime() {
		return endTime;
	}

	public Timestamp getEnd_time() {
		return endTime == null ? null : Timestamp.valueOf(endTime);
	}

	public void setEndTime(LocalDateTime endTime) {
		this.endTime = endTime;
	}

	public int getPrice() {
		return price;
	}

	public void setPrice(int price) {
		this.price = price;
	}

	@Override
	public String toString() {
		return "ScheduleDTO [scheduleId=" + scheduleId + ", movieId=" + movieId + ", screenId=" + screenId
				+ ", startTime=" + startTime + ", endTime=" + endTime + ", price=" + price + "]";
	}

}
