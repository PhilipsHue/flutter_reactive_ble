package com.signify.hue.flutterreactiveble.debugutils

object PerformanceAnalyzer {

    var timer = Pair<Long, Long>(0, 0)

    fun start(startTime: Long) {
        timer = timer.copy(first = startTime)
    }

    fun end(endTime: Long) {
        timer = timer.copy(second = endTime)
    }

    fun timeElapsed(): Long = timer.second - timer.first
}
