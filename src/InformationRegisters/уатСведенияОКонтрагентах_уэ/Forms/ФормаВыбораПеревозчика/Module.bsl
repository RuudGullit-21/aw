
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	ОтображатьТолькоПеревозчиков = Истина;
	
	УстановитьСнятьОтборПоПеревозчикам();
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы

&НаКлиенте
Процедура ОтображатьТолькоПеревозчиковПриИзменении(Элемент)
	
	УстановитьСнятьОтборПоПеревозчикам();
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаСервере
Процедура УстановитьСнятьОтборПоПеревозчикам()
	
	ОбщегоНазначенияКлиентСервер.УстановитьЭлементОтбораДинамическогоСписка(
		Список, 
		"Перевозчик", 
		Истина, 
		ВидСравненияКомпоновкиДанных.Равно, 
		"Показывать только перевозчиков",
		ОтображатьТолькоПеревозчиков,
		РежимОтображенияЭлементаНастройкиКомпоновкиДанных.Недоступный,
		"ОтображатьТолькоПеревозчиков");
	
КонецПроцедуры

#КонецОбласти
