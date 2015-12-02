/*
 * Copyright (c) 2012 Tobias Goeschel.
 *
 * Permission is hereby granted, free of charge, to any person
 * obtaining a copy of this software and associated documentation
 * files (the "Software"), to deal in the Software without restriction,
 * including without limitation the rights to use, copy, modify, merge,
 * publish, distribute, sublicense, and/or sell copies of the Software,
 * and to permit persons to whom the Software is furnished to do so,
 * subject to the following conditions:
 *
 * The above copyright notice and this permission notice shall be
 * included in all copies or substantial portions of the Software.
 *
 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
 * EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES
 * OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
 * NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT
 * HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY,
 * WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
 * OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER
 * DEALINGS IN THE SOFTWARE.
 */

package org.robotrunk.ui.page.impl {
	import flash.display.Sprite;
	import flash.events.Event;

	import org.robotrunk.ui.core.event.ViewEvent;
	import org.robotrunk.ui.page.api.PageElement;

	public class SimplePageElementImpl extends Sprite implements PageElement {
		private var _data:XML;
		private var _elementIndex:int;

		public function SimplePageElementImpl( data:XML ) {
			_data = data;
			addEventListener( Event.ADDED_TO_STAGE, onAddedToStage );
		}

		private function onAddedToStage( ev:Event ):void {
			removeEventListener( Event.ADDED_TO_STAGE, onAddedToStage );
			dispatchEvent( new ViewEvent( ViewEvent.RENDER ) );
			dispatchEvent( new ViewEvent( ViewEvent.RENDER_COMPLETE ) );
		}

		public function destroy():void {
			_data = null;
			_elementIndex = 0;
		}

		public function get data():XML {
			return _data;
		}

		public function get elementIndex():int {
			return _data.@elementindex != null ? _data.@elementindex.valueOf() : _elementIndex;
		}

		public function set elementIndex( index:int ):void {
			_elementIndex = index;
		}
	}
}
