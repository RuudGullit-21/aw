
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	ТочностьОкругления = 0.1;
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура ОК(Команда)
	СтруктураНастроек = Новый Структура("ТочностьОкругления, РежимОкругления", ТочностьОкругления, РежимОкругления);
	Закрыть(СтруктураНастроек);
КонецПроцедуры

#КонецОбласти
