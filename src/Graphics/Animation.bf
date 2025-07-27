/*******************************************************************************
 * Copyright 2011 See AUTHORS file.
 * 
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 * 
 *   http://www.apache.org/licenses/LICENSE-2.0
 * 
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 ******************************************************************************/

namespace GameUtils;

using System;
using System.Collections;
using SDL3.Raw;

/**
 * An Animation stores a list of objects representing an animated sequence, e.g. for running or jumping. Each object in the
 * Animation is called a key frame, and multiple key frames make up the animation.

 * @author mzechner
*/

public class Animation<T> where T : SDL_Texture {

	public enum PlayMode {
		NORMAL, REVERSED, LOOP, LOOP_REVERSED, LOOP_PINGPONG, LOOP_RANDOM,
	}

	T[] keyFrames;
	private float frameDuration;
	private float animationDuration;
	private int lastFrameNumber;
	private float lastStateTime;

	private PlayMode playMode = PlayMode.NORMAL;

	public this(float frameDuration, List<T> keyFrames) {
		this.frameDuration = frameDuration;
		T[] array = scope T[keyFrames.Count];
		keyFrames.CopyTo(array);
		setKeyFrames(array);
	}

	public this(float frameDuration, params T[] keyFrames) {
		this.frameDuration = frameDuration;
		setKeyFrames(keyFrames);
	}

	public T getKeyFrame(float stateTime, bool looping) {
		// we set the play mode by overriding the previous mode based on looping
		// parameter value
		PlayMode oldPlayMode = playMode;
		if (looping && (playMode == PlayMode.NORMAL || playMode == PlayMode.REVERSED)) {
			if (playMode == PlayMode.NORMAL)
				playMode = PlayMode.LOOP;
			else
				playMode = PlayMode.LOOP_REVERSED;
		} else if (!looping && !(playMode == PlayMode.NORMAL || playMode == PlayMode.REVERSED)) {
			if (playMode == PlayMode.LOOP_REVERSED)
				playMode = PlayMode.REVERSED;
			else
				playMode = PlayMode.LOOP;
		}

		T frame = getKeyFrame(stateTime);
		playMode = oldPlayMode;
		return frame;
	}

	public T getKeyFrame(float stateTime) {
		int frameNumber = getKeyFrameIndex(stateTime);
		return keyFrames[frameNumber];
	}

	public int getKeyFrameIndex(float stateTime) {
		if (keyFrames.Count == 1) return 0;

		int frameNumber = (int)(stateTime / frameDuration);
		switch (playMode) {
		case PlayMode.NORMAL:
			frameNumber = Math.Min(keyFrames.Count - 1, frameNumber);
			break;
		case PlayMode.LOOP:
			frameNumber = frameNumber % keyFrames.Count;
			break;
		case PlayMode.LOOP_PINGPONG:
			frameNumber = frameNumber % ((keyFrames.Count * 2) - 2);
			if (frameNumber >= keyFrames.Count) frameNumber = keyFrames.Count - 2 - (frameNumber - keyFrames.Count);
			break;
		case PlayMode.LOOP_RANDOM:
			int lastFrameNumber = (int)((lastStateTime) / frameDuration);
			if (lastFrameNumber != frameNumber) {
				frameNumber = MathUtils.random(keyFrames.Count - 1);
			} else {
				frameNumber = this.lastFrameNumber;
			}
			break;
		case PlayMode.REVERSED:
			frameNumber = Math.Max(keyFrames.Count - frameNumber - 1, 0);
			break;
		case PlayMode.LOOP_REVERSED:
			frameNumber = frameNumber % keyFrames.Count;
			frameNumber = keyFrames.Count - frameNumber - 1;
			break;
		default:
			break;
		}

		lastFrameNumber = frameNumber;
		lastStateTime = stateTime;

		return frameNumber;
	}

	public T[] getKeyFrames() {
		return keyFrames;
	}

	protected void setKeyFrames(params T[] keyFrames) {
		this.keyFrames = keyFrames;
		this.animationDuration = keyFrames.Count * frameDuration;
	}

	protected void setKeyFrames(T[] keyFrames) {
		this.keyFrames = keyFrames;
		this.animationDuration = keyFrames.Count * frameDuration;
	}

	public PlayMode getPlayMode() {
		return playMode;
	}

	public void setPlayMode(PlayMode playMode) {
		this.playMode = playMode;
	}

	public bool isAnimationFinished(float stateTime) {
		int frameNumber = (int)(stateTime / frameDuration);
		return keyFrames.Count - 1 < frameNumber;
	}

	public void setFrameDuration(float frameDuration) {
		this.frameDuration = frameDuration;
		this.animationDuration = keyFrames.Count * frameDuration;
	}

	public float getFrameDuration() {
		return frameDuration;
	}

	public float getAnimationDuration() {
		return animationDuration;
	}
}
