#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)

	Если Параметры.Свойство("АвтоТест") Тогда // Возврат при получении формы для анализа.
		Возврат;
	КонецЕсли;
	
	Если Параметры.Свойство("НеДанныйСценарий") Тогда
		
		СсылкаНаДанныйСценарий = Параметры.НеДанныйСценарий;
		
		ОтборыСписковКлиентСервер.УстановитьЭлементОтбораСписка(
			Список, "Ссылка", СсылкаНаДанныйСценарий, ВидСравненияКомпоновкиДанных.НеРавно);
		
	КонецЕсли;
	
	//СобытияФорм.ПриСозданииНаСервере(ЭтотОбъект, Отказ, СтандартнаяОбработка);
	
КонецПроцедуры

#КонецОбласти
#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура Подключаемый_ВыполнитьПереопределяемуюКоманду(Команда)
	
	//СобытияФормКлиент.ВыполнитьПереопределяемуюКоманду(ЭтотОбъект, Команда);
	Заглушка = Истина;
	
КонецПроцедуры

#КонецОбласти

