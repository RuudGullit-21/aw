
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Параметры.Свойство("ДатаКалендаря", ДатаКалендаря)
	
КонецПроцедуры // ПриСозданииНаСервере()

#КонецОбласти


#Область ОбработчикиСобытийЭлементовШапкиФормы

&НаКлиенте
Процедура ДатаКалендаряПриАктивизацииДаты(Элемент)
	
	ПодключитьОбработчикОжидания("ОбработкаОжидания", 0.2, Истина);
	
КонецПроцедуры // ДатаКалендаряПриАктивизацииДаты()

#КонецОбласти


#Область СлужебныеПроцедурыИФункции

&НаКлиенте
Процедура ОбработкаОжидания()
	
	Для каждого ВыделеннаяДата Из Элементы.ДатаКалендаря.ВыделенныеДаты Цикл
		
		ДатаКалендаря = ВыделеннаяДата;
		
	КонецЦикла;
	
	ОповеститьОВыборе(ДатаКалендаря);
	
КонецПроцедуры // ОбработкаОжидания()

#КонецОбласти


