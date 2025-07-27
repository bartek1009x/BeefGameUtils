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

namespace GameUtils.Utils.Viewport;

using System;
using GameUtils.Utils;
using GameUtils.Graphics;

/** A viewport that scales the world using Scaling.
 * <p>
 * Scaling.fit keeps the aspect ratio by scaling the world up to fit the screen, adding black bars (letterboxing) for the
 * remaining space.
 * <p>
 * Scaling.fill keeps the aspect ratio by scaling the world up to take the whole screen (some of the world may be off
 * screen).
 * <p>
 * Scaling.stretch does not keep the aspect ratio, the world is scaled to take the whole screen.
 * <p>
 * Scaling.none keeps the aspect ratio by using a fixed size world (the world may not fill the screen or some of the world
 * may be off screen).
 * @author Daniel Holderbaum
 * @author Nathan Sweet */
public class ScalingViewport : Viewport {
	private Scaling scaling;

	/** Creates a new viewport using a new OrthographicCamera. */
	public this(Scaling scaling, float worldWidth, float worldHeight) : this(scaling, worldWidth, worldHeight, new OrthographicCamera()) {}

	public this(Scaling scaling, float worldWidth, float worldHeight, Camera camera) {
		this.scaling = scaling;
		setWorldSize(worldWidth, worldHeight);
		setCamera(camera);
	}

	new public void update (int screenWidth, int screenHeight, bool centerCamera) {
		Vector2 scaled = scaling.apply(getWorldWidth(), getWorldHeight(), screenWidth, screenHeight);
		int viewportWidth = (int) Math.Round(scaled.x);
		int viewportHeight = (int) Math.Round(scaled.y);

		// Center.
		setScreenBounds((screenWidth - viewportWidth) / 2, (screenHeight - viewportHeight) / 2, viewportWidth, viewportHeight);

		apply(centerCamera);
	}

	public Scaling getScaling () {
		return scaling;
	}

	public void setScaling (Scaling scaling) {
		this.scaling = scaling;
	}
}