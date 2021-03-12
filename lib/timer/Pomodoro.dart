enum Status {
  work,
  shortBreak,
}

class Pomodoro {
  Duration targetTime;
  Status status;

  Pomodoro({
    this.targetTime,
    this.status,
  });

  void setParam({Duration time, Status status}) {
    this.targetTime = time;
    this.status = status;
  }
}