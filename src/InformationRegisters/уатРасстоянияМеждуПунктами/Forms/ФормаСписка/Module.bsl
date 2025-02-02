
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	ТекПунктПараметр = Неопределено;
	Параметры.Свойство("ПунктНазначения", ТекПунктПараметр);
	ОбщегоНазначенияКлиентСервер.УстановитьПараметрДинамическогоСписка(Список, "Пункт", ТекПунктПараметр);
	
	// уатУправлениеАвтотранспортом.МодификацияКонфигурации
	уатМодификацияКонфигурацииПереопределяемый.ПриСозданииНаСервере(ЭтотОбъект, Отказ, СтандартнаяОбработка);
	// Конец уатУправлениеАвтотранспортом.МодификацияКонфигурации
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

// уатУправлениеАвтотранспортом.МодификацияКонфигурации
&НаКлиенте
Процедура Подключаемый_уатВыполнитьКоманду(Команда)
	
	уатМодификацияКонфигурацииКлиентПереопределяемый.ВыполнитьПодключаемуюКоманду(ЭтотОбъект, Команда);
	
КонецПроцедуры
// Конец уатУправлениеАвтотранспортом.МодификацияКонфигурации

#КонецОбласти