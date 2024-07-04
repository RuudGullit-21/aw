
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	Если Параметры.Свойство("ЭтоАРМДиспетчера") Тогда
		Заголовок = Нстр("ru = 'АРМ Диспетчера: Сортировка'");
	КонецЕсли;
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	
	КомпоновщикДанныхЗаказов = ВладелецФормы.ЗаказыСписок.КомпоновщикНастроек;

КонецПроцедуры

#КонецОбласти


#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура ОК(Команда)
	
	КомпоновщикДанныхЗаказовПорядок = КомпоновщикДанныхЗаказов.Настройки.Порядок;
	
	МассивДляУдаления = Новый Массив();
	Для Каждого ТекСтрока Из КомпоновщикДанныхЗаказовПорядок.Элементы Цикл
		Если НЕ ЗначениеЗаполнено(ТекСтрока.Поле) Тогда
			МассивДляУдаления.Добавить(ТекСтрока);
		КонецЕсли;
	КонецЦикла;
	
	Для Каждого ТекСтрока Из МассивДляУдаления Цикл
		КомпоновщикДанныхЗаказовПорядок.Элементы.Удалить(ТекСтрока);
	КонецЦикла;
	
	Закрыть(КомпоновщикДанныхЗаказовПорядок.Элементы);
	
КонецПроцедуры

#КонецОбласти
