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

package org.robotrunk.ui.page.api {
	import flash.events.IEventDispatcher;
	import flash.utils.Dictionary;

	import mx.collections.ArrayCollection;

	import org.robotrunk.ui.core.api.UIComponent;
	import org.robotrunk.ui.page.impl.ElementRenderer;

	public interface Page extends UIComponent, IEventDispatcher {
		function addRenderer( type:String, elementRenderer:ElementRenderer ):void;

		function get renderers():Dictionary;

		function set dataProvider( dataProvider:XML ):void;

		function get dataProvider():XML;

		function render():void;

		function get elements():ArrayCollection;

		function set id( id:String ):void;

		function get id():String;
	}
}
