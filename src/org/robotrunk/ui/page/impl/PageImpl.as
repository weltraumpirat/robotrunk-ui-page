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
	import flash.display.DisplayObject;
	import flash.utils.Dictionary;

	import mx.collections.ArrayCollection;

	import org.robotools.data.sorting.NumericSort;
	import org.robotrunk.ui.core.event.ViewEvent;
	import org.robotrunk.ui.core.impl.UIComponentImpl;
	import org.robotrunk.ui.page.api.Page;
	import org.robotrunk.ui.page.api.PageElement;
	import org.robotrunk.ui.page.event.PageEvent;

	public class PageImpl extends UIComponentImpl implements Page {
		private var _renderers:Dictionary;
		private var _dataProvider:XML;
		private var _elements:ArrayCollection;
		private var _itemsRendered:int = 0;
		private var _id:String;

		public function render():void {
			dispatchEvent( new ViewEvent( ViewEvent.RENDER ) );
			if( _elements ) {
				destroyElements();
			}
			createElements();
			sortElements();
			renderElements();
		}

		private function destroyElements():void {
			if( _elements ) {
				for each( var elm:DisplayObject in _elements ) {
					if( contains( elm ) ) {
						removeChild( elm );
					}
				}
				_elements.removeAll();
			}
			_elements = null;
			_itemsRendered = 0;
		}

		private function renderElements():void {
			for each( var elm:DisplayObject in _elements ) {
				addChild( elm );
			}
		}

		private function sortElements():void {
			_elements.sort = new NumericSort( ["elementIndex"] );
			_elements.refresh();
		}

		private function createElements():void {
			_elements ||= new ArrayCollection();
			var elements:XMLList = _dataProvider.elements();
			for each( var node:XML in elements ) {
				_elements.addItem( createElementFromNode( node ) );
			}
		}

		private function layout():void {
			var position:Number = 0;
			var maxWidth:Number = 0;
			var offset:Number = style && style.offset ? style.offset : 0;
			for each( var element:PageElement in elements ) {
				if( element.visible ) {
					element.y = position;
					position += offset+element.height;
					maxWidth = maxWidth>element.width ? maxWidth : element.width;
				}
			}
			width = maxWidth;
			height = position-offset;
			dispatchEvent( new PageEvent( PageEvent.UPDATE, true ) );
		}

		override protected function update():void {
			width = super.width;
			height = super.height;
			positionComponent();
		}

		private function createElementFromNode( node:XML ):PageElement {
			var element:PageElement = createElement( node );
			element.addEventListener( ViewEvent.RENDER_COMPLETE, onElementRenderComplete, false, 0, true );
			return element;
		}

		private function onElementRenderComplete( ev:ViewEvent ):void {
			if( ++_itemsRendered == elements.length ) {
				dispatchEvent( new ViewEvent( ViewEvent.RENDER_COMPLETE ) );
			}
			layout();
		}

		private function createElement( node:XML ):PageElement {
			var name:String = node.name() != null ? node.name().toString() : "default";
			var renderer:* = _renderers[name];
			if( !renderer ) {
				renderer = _renderers["default"];
			}
			return renderer.create( node );
		}

		override public function destroy():void {
			_renderers = null;
			destroyElements();
		}

		public function addRenderer( type:String, elementRenderer:ElementRenderer ):void {
			_renderers ||= new Dictionary();
			_renderers[type] = elementRenderer;
		}

		public function get renderers():Dictionary {
			return _renderers;
		}

		public function get dataProvider():XML {
			return _dataProvider;
		}

		public function set dataProvider( value:XML ):void {
			_dataProvider = value;
		}

		public function get elements():ArrayCollection {
			return _elements;
		}

		public function set elements( value:ArrayCollection ):void {
			_elements = value;
		}

		public function get id():String {
			return _id;
		}

		public function set id( value:String ):void {
			_id = value;
		}
	}
}
