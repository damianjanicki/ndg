/*
*  Copyright (C) 2010  INdT - Instituto Nokia de Tecnologia
*
*  NDG is free software; you can redistribute it and/or
*  modify it under the terms of the GNU Lesser General Public
*  License as published by the Free Software Foundation; either 
*  version 2.1 of the License, or (at your option) any later version.
*
*  NDG is distributed in the hope that it will be useful,
*  but WITHOUT ANY WARRANTY; without even the implied warranty of
*  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
*  Lesser General Public License for more details.
*
*  You should have received a copy of the GNU Lesser General Public 
*  License along with NDG.  If not, see <http://www.gnu.org/licenses/ 
*/

package main.br.org.indt.ndg.controller.editor
{
	import mx.collections.ArrayCollection;
	import main.br.org.indt.ndg.controller.editor.*;
	import main.br.org.indt.ndg.i18n.ConfigI18n;
	
	public class Question
	{
		public static const STRING_TYPE:String = "_str";
		public static const CHOICE_TYPE:String = "_choice";
		public static const CHOICE_EXCLUSIVE_TYPE:String = "_choiceExclusive";
		public static const INTEGER_TYPE:String = "_int";
		public static const DECIMAL_TYPE:String = "_decimal";
		public static const DATE_TYPE:String = "_date";
		public static const IMAGE_TYPE:String = "_img";
		
		public static const QUESTION_STRING:int = 1;
		public static const QUESTION_INTEGER:int = 2;
		public static const QUESTION_DATE:int = 3;
		public static const QUESTION_CHOICE:int = 4;
		public static const QUESTION_CHOICE_EXCLUSIVE:int = 5;
		public static const QUESTION_IMAGE:int = 6;
		//public static const QUESTION_TIME:int = 7;
		
		public static const QUESTION_DEFAULT_DISPLAY_NAME:String = ConfigI18n.getInstance().getStringFile("editorResources", "NEW_QUESTION");
		
		private var content:XML;
		private var type:String;
		private var lastIndexAvailable:int = 1;
		
		public function Question(type:String)
        {
        	this.type = type;
        }
        
        
        public function setContent(index:int):void
        {
        	/* var field:String = "";
        	var direction:String = "in"; */
        	var editable:Boolean = true;
        	var min:String = "";
        	var max:String = "";
        	var description:String = Question.QUESTION_DEFAULT_DISPLAY_NAME;
        	var choice_item:String = ConfigI18n.getInstance().getStringFile("editorResources", "CHOICE");
        	
        	if(type == STRING_TYPE)
        	{
	        	content = <question id={index} type={type} field={""} direction={"in"} editable={editable}>
					        	<description>{description}</description>
					        	<length>50</length>
					      </question>;
			}
			else if(type == CHOICE_TYPE)
			{
				content = <question id={index} type={type} field={""} direction={"in"} editable={editable}>
								<description>{description}</description>
								<select>multiple</select>
								<item otr="0">{choice_item + " 1"}</item>
								<item otr="0">{choice_item + " 2"}</item>
						</question>;
			}
			else if(type == CHOICE_EXCLUSIVE_TYPE)
			{
				content = <question id={index} type={CHOICE_TYPE} field={""} direction={"in"} editable={editable}>
								<description>{description}</description>
								<select>exclusive</select>
								<item otr="0">{choice_item + " 1"}</item>
								<item otr="0">{choice_item + " 2"}</item>
						</question>;
			}
			else if(type == INTEGER_TYPE)
			{
				content = <question id={index} type={type} field={""} direction={"in"} editable={editable} min={min} max={max}>
					        	<description>{description}</description>
					        	<length>10</length>
					      </question>;				
			}
			else if (type == DATE_TYPE)
			{
				content = <question id={index} type={type} field={""} direction={"in"} editable={editable} min={min} max={max}>
					        	<description>{description}</description>
					      </question>;				
			}
			else if (type == IMAGE_TYPE)
			{
				content = <question id={index} type={type} field={""} direction={"in"} editable={editable}>
					        	<description>{description}</description>
					      </question>;				
			}
			else
			{
				throw new ArgumentError("Invalid Question Type: " + type);
			}
        }
        
        public function getContent():XML
        {
        	return content;
        }
        
                
        public static function updateQuestion(question:XML, attributes:AttributeList):void
        {        	
			var questionType:String = question.@type;
    		if(questionType==STRING_TYPE)
			{
				editStringQuestion(question, attributes);
			}
			else if(questionType ==  CHOICE_TYPE)
			{
				editChoiceQuestion(question, attributes);
			}
			else if ( (questionType ==  INTEGER_TYPE) || (questionType ==  DECIMAL_TYPE) )
			{
				editIntegerQuestion(question, attributes);
			}
			else if(questionType ==  DATE_TYPE)
			{
				editDateQuestion(question, attributes);
			}
			else if(questionType ==  IMAGE_TYPE)
			{
				editImageQuestion(question, attributes);
			}
			else
			{
				throw new ArgumentError("Invalid question type");
			}
        }
        
        
        //put in subclass StringQuestion ?
        private static function editStringQuestion(question:XML, attributes:AttributeList):void
        {
        	question.description = attributes.getDescription();
        	question.length = attributes.getLength();
        	/* question.@field = attributes.getMLCField();
        	question.@direction = attributes.getMLCDirection(); */
        	question.@editable = (attributes.getMLCEditable() == true) ? "true" : "false";
        }
        
        private static function editChoiceQuestion(question:XML, attributes:AttributeList):void
        {
        	question.description = attributes.getDescription();
        	question.select = getChoiceType(attributes);
        	/* question.@field = attributes.getMLCField();
        	question.@direction = attributes.getMLCDirection(); */
        	question.@editable = (attributes.getMLCEditable() == true) ? "true" : "false";
        }
        
        private static function editIntegerQuestion(question:XML, attributes:AttributeList):void
        {
        	question.description = attributes.getDescription();    
        	question.length = attributes.getLength();
        	question.@min = attributes.getMinRange();
        	question.@max = attributes.getMaxRange();
        	/* question.@field = attributes.getMLCField();
        	question.@direction = attributes.getMLCDirection(); */
        	question.@editable = (attributes.getMLCEditable() == true) ? "true" : "false";
            
        	if (attributes.getDecimalAllowed())
        	{
        		question.@type = Question.DECIMAL_TYPE;
        	}
        	else
        	{
        		question.@type = Question.INTEGER_TYPE;
        	}
        }
        
        private static function editDateQuestion(question:XML, attributes:AttributeList):void
        {
        	question.description = attributes.getDescription();
        	question.@min = attributes.getMinRange();
        	question.@max = attributes.getMaxRange();        	
        	/* question.@field = attributes.getMLCField();
        	question.@direction = attributes.getMLCDirection(); */
        	question.@editable = (attributes.getMLCEditable() == true) ? "true" : "false";
        }
        
        private static function editImageQuestion(question:XML, attributes:AttributeList):void
        {
        	question.description = attributes.getDescription();
        	/* question.@field = attributes.getMLCField();
        	question.@direction = attributes.getMLCDirection(); */
        	question.@editable = (attributes.getMLCEditable() == true) ? "true" : "false";
        }
        
        private static function getChoiceType(attributes:AttributeList):String
        {
        	if(attributes.isExclusive() )
        		return "exclusive";
        	else 
        		return "multiple";
        }
        
        
        public static function isExclusiveChoice(question:XML):Boolean
        {
        	if(question.select == "exclusive")
        		return true;
        	return false;        	        	
        }
        
        public static function insertSkipLogic(skipLogicOriginNode:XML, gotoNode:XML, skipLogicOptionIndex:int, skipLogicOperator:int):void
        {
        	var categoryParent:XML = gotoNode.parent();
        	
        	//this code works if several SkipLogic tags could exist within a "question" node
        	//var skipLogic:XML = <SkipLogic catTo={categoryParent.@id} operand={skipLogicOptionIndex} operator="0" skipTo={gotoNode.@id} /> ;        	
        	//skipLogicOriginNode.appendChild(skipLogic);
        	
        	//this code works for just one SkipLogic tag for question
        	skipLogicOriginNode.SkipLogic.@catTo = categoryParent.@id;
        	skipLogicOriginNode.SkipLogic.@operand = skipLogicOptionIndex;
        	skipLogicOriginNode.SkipLogic.@operator = skipLogicOperator;
        	skipLogicOriginNode.SkipLogic.@skipTo = gotoNode.@id;
        }
        
        public static function clearSkipLogic(question:XML, nIndex:int):void
        {
        	if (question != null)
        	{
        		var children:XMLList = question.children(); 
				for (var i:int=0; i < question.children().length(); i++)
				{
					if (children[i].localName() == "SkipLogic")
						if (children[i].@operand == nIndex)
						{
							delete children[i];
							break;
						} 
				}
        	}
        }
        
        public function getId():int
        {
        	return content.@id;
        }
        
        public static function getChoiceItensCountByQuestion(question:XML):int
		{
			if(question.localName() == "question")
			{
				var count:int = 0;
				var children:XMLList = question.children(); 
				for (var i:int=0; i < question.children().length(); i++)
				{
					if (children[i].localName() == "item")
						count++;
				} 
			}
			else
			{
				throw new ArgumentError("Node is not a Question");
			}
			
			return count;
		}
		
		public static function addChoiceItem(node:XML, nIndex:int):void
		{
			node.item[nIndex] = ConfigI18n.getInstance().getStringFile("editorResources", "CHOICE") + " " + (nIndex + 1).toString();
			node.item[nIndex].@otr = "0";
		}
		
		public static function editChoiceItem(node:XML, choiceIndex:int, txtChoiceItem:String, intOtr:int):void 
		{
			node.item[choiceIndex] = txtChoiceItem;
			node.item[choiceIndex].@otr = intOtr;
		}
        
        public static function removeChoiceItem(node:XML, choiceIndex:int): void
		{
			 var count:int = 0;
			 var children:XMLList = node.children();
		     var length:int = children.length();
		     for(var i:int=0; i < length; i++)
		     {
				  if (children[i].localName() == "item")
				  {
					if (count == choiceIndex)
					{
						delete children[i];					      
						break;
					}
					 
					 count++;
				  }
		     } 
		}
		
		public static function populateList(question: XML):ArrayCollection
		{
			var aItens:ArrayCollection = new ArrayCollection();
			if(question.localName() == "question")
			{
				var count:int = 0;
				var children:XMLList = question.children(); 
				for (var i:int=0; i < question.children().length(); i++)
				{
					if (children[i].localName() == "item")
						aItens.addItem(children[i]);
				} 
			}
			else
			{
				throw new ArgumentError("Parameter is not a Question Item");
			}
			
			return aItens;
		}
		
		public static function getSkipLogicNode(question: XML, nIndex:int):XML
		{
			var xmlResult:XML;
			if(question.localName() == "question")
			{
				var children:XMLList = question.children(); 
				for (var i:int=0; i < question.children().length(); i++)
				{
					if (children[i].localName() == "SkipLogic")
						if (children[i].@operand == nIndex)
						{
							xmlResult = children[i];
							break;
						} 
				} 
			}
			else
			{
				throw new ArgumentError("Node is not a Question");
			}
			return xmlResult;
		}
 	}	
}