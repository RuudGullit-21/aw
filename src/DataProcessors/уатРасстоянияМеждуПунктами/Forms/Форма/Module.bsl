#Область ОбработчикиСобытийФормы

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	
	Отказ = Истина;
	ТекстНСТР = НСтр("en='This processing is called only for the presentation of contact information"
"without using the processing form.';ru='Эта обработка вызывается только для представления контактной информации "
"без использования формы обработки.'");
	ТекстЗаголовок = НСтр("en='Representation of contact information.';ru='Представление контактной информации.'");
	ПоказатьПредупреждение(Неопределено, ТекстНСТР,,ТекстЗаголовок);
	
КонецПроцедуры

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Отказ = Истина;
		
КонецПроцедуры

#КонецОбласти
