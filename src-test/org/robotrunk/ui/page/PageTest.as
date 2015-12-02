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

package org.robotrunk.ui.page {
	import flash.display.DisplayObject;

	import mx.core.UIComponent;

	import org.flexunit.asserts.assertEquals;
	import org.flexunit.asserts.assertNotNull;
	import org.flexunit.asserts.assertNull;
	import org.flexunit.async.Async;
	import org.fluint.uiImpersonation.UIImpersonator;
	import org.robotrunk.ui.core.Style;
	import org.robotrunk.ui.core.event.ViewEvent;
	import org.robotrunk.ui.page.api.Page;
	import org.robotrunk.ui.page.api.PageElement;
	import org.robotrunk.ui.page.impl.ElementRenderer;
	import org.robotrunk.ui.page.impl.PageImpl;
	import org.robotrunk.ui.page.impl.SimplePageElementImpl;

	public class PageTest {
		private var page:Page;

		[Before]
		public function setUp():void {
			page = new PageImpl();
		}

		[Test]
		public function acceptsXMLDataProvider():void {
			var prov:XML = new XML();
			page.dataProvider = prov;
			assertEquals( prov, page.dataProvider );
		}

		[Test]
		public function holdsElementRenderers():void {
			var elementRenderer:ElementRenderer = new ElementRenderer( SimplePageElementImpl );
			page.addRenderer( "thing", elementRenderer );
			assertEquals( elementRenderer, page.renderers["thing"] );
		}

		[Test]
		public function rendersPageElements():void {
			setUpForRendering();
			page.render();
			assertEquals( 2, page.elements.length );
		}

		[Test]
		public function sortsElementsByElementIndex():void {
			setUpForRendering();
			page.render();
			var elm1:PageElement = page.elements.getItemAt( 0 ) as PageElement;
			assertEquals( 1, elm1.elementIndex );
			var elm2:PageElement = page.elements.getItemAt( 1 ) as PageElement;
			assertEquals( 2, elm2.elementIndex );
		}

		[Test]
		public function mapsXMLElementsToPageElements():void {
			var data:XML = createDummyPage();
			page.dataProvider = data;
			page.addRenderer( "textbox", new ElementRenderer( SimplePageElementImpl ) );
			page.addRenderer( "table", new ElementRenderer( SimplePageElementImpl ) );
			page.render();
			var elm1:PageElement = page.elements.getItemAt( 0 ) as PageElement;
			var elm2:PageElement = page.elements.getItemAt( 1 ) as PageElement;
			assertEquals( data.textbox, elm2.data );
			assertEquals( data.table, elm1.data );
		}

		[Test(async, ui)]
		public function elementsArePlacedBelowEachOther():void {
			var style:Style = new Style();
			style.offset = 10;
			page.style = style;
			page.dataProvider = createDummyPage();
			page.addRenderer( "textbox", new ElementRenderer( DummyPageElementImpl ) );
			page.addRenderer( "table", new ElementRenderer( DummyPageElementImpl ) );
			page.addEventListener( ViewEvent.RENDER_COMPLETE, Async.asyncHandler( this, onPageRenderComplete, 500 ) );
			var container:UIComponent = new UIComponent();
			UIImpersonator.addChild( container );
			container.addChild( page as DisplayObject );
			page.render();

		}

		private function onPageRenderComplete( ev:ViewEvent, ...rest ):void {
			var elm1:PageElement = page.elements.getItemAt( 0 ) as PageElement;
			var elm2:PageElement = page.elements.getItemAt( 1 ) as PageElement;
			assertEquals( 0, elm1.y );
			assertEquals( 110, elm2.y );
		}

		private function setUpForRendering():void {
			page.dataProvider = createDummyPage();
			page.addRenderer( "textbox", new ElementRenderer( SimplePageElementImpl ) );
			page.addRenderer( "table", new ElementRenderer( SimplePageElementImpl ) );
		}

		private function createDummyPage():XML {
			return <page>
				<textbox elementindex="2"></textbox>
				<table elementindex="1"></table>
			</page>;
		}

		[Test]
		public function cleansUpNicely():void {
			page.addRenderer( "thing", new ElementRenderer( SimplePageElementImpl ) );
			assertNotNull( page.renderers );
			page.destroy();
			assertNull( page.renderers );
		}

		[After]
		public function tearDown():void {
			UIImpersonator.removeAllChildren();
			page.destroy();
			page = null;
		}
	}
}

import flash.geom.Rectangle;

import org.robotools.graphics.drawing.GraphRectangle;
import org.robotrunk.ui.page.impl.SimplePageElementImpl;

internal class DummyPageElementImpl extends SimplePageElementImpl {

	public function DummyPageElementImpl( data:XML ) {
		super( data );
		new GraphRectangle( this ).createRectangle( new Rectangle( 0, 0, 100, 100 ) ).fill( 0, 1 ).draw();
	}
}