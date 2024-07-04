
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Параметры.Свойство("НастройкаРежимОптимизации",       НастройкаРежимОптимизации);
	Параметры.Свойство("НастройкаПараметрРазмераЗаказа",  НастройкаПараметрРазмераЗаказа);
	Параметры.Свойство("НастройкаПриоритетМаршрутизации", НастройкаПриоритетМаршрутизации);
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура СохранитьНастройки(Команда)
	
	РезультатЗакрытия = Новый Структура();
	РезультатЗакрытия.Вставить("НастройкаРежимОптимизации",       НастройкаРежимОптимизации);
	РезультатЗакрытия.Вставить("НастройкаПараметрРазмераЗаказа",  НастройкаПараметрРазмераЗаказа);
	РезультатЗакрытия.Вставить("НастройкаПриоритетМаршрутизации", НастройкаПриоритетМаршрутизации);
	
	Закрыть(РезультатЗакрытия);
	
КонецПроцедуры

#КонецОбласти
