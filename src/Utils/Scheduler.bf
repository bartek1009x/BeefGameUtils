// this file is under MIT because I wrote it myself

namespace GameUtils.Utils;

using System;
using System.Collections;
using System.Diagnostics;
using System.Threading;

class Scheduler {

	List<ScheduledFunction> scheduledFunctions = new List<ScheduledFunction>(1);
	public Thread timerThread;

	public this() {}

	public class ScheduledFunction {

		public bool cancel = false;
		public readonly int64 startTime;
		public delegate void() func;
		public readonly int64 delay;

		public this(delegate void() func, float delay) {
			this.startTime = DateTime.Now.Ticks;
			this.delay = (int64) (delay * 10000000);
			this.func = func;
		}
	}

	public int delayFunction(delegate void() func, float delay) {

		scheduledFunctions.Add(new ScheduledFunction(func, delay));

		if (timerThread == null) {
			timerThread = scope Thread(new () => {

				while (scheduledFunctions.Count != 0) {

					Thread.Sleep(10);

					int64 now = DateTime.Now.Ticks;

					for (ScheduledFunction scheduled in scheduledFunctions) {
						if (scheduled.cancel) {
							scheduledFunctions.Remove(scheduled);
							delete scheduled;
						} else if (now - scheduled.startTime > scheduled.delay) {
							scheduled.func();

							scheduledFunctions.Remove(scheduled);
							delete scheduled;
						}
					}

				}

				Debug.WriteLine($"Count {scheduledFunctions.Count}");

				timerThread = null;

			});

			timerThread.AutoDelete = false;
			timerThread.Start();
		}

		return scheduledFunctions.Count - 1;
	}

	public void cancel(int index) {

		scheduledFunctions[index].cancel = true;

	}

}