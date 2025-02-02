#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ОбработчикиСобытий

Процедура ПередЗаписью(Отказ, Замещение)
	
	Если ОбменДанными.Загрузка Тогда 
		Возврат; 
	КонецЕсли;
 	
	ОбновлениеИнформационнойБазы.ПроверитьОбъектОбработан(ЭтотОбъект);
	
	// {УАТ}
	СтарыйНабор = РегистрыСведений.СостоянияПоОбъектамУчетаЭДО.СоздатьНаборЗаписей();
	Для Каждого ЭлементОтбора Из Отбор Цикл
		Если ЭлементОтбора.Использование Тогда
			СтарыйНабор.Отбор[ЭлементОтбора.Имя].Установить(ЭлементОтбора.Значение);
		КонецЕсли;
	КонецЦикла;
	СтарыйНабор.Прочитать();
	
	ДокументыВНаборе    = Новый Массив(); 
	СоответвиеСостояний = Новый Соответствие();
	Для Каждого СтрокаНабора Из СтарыйНабор Цикл  
		Если (ТипЗнч(СтрокаНабора.СсылкаНаОбъект) = Тип("ДокументСсылка.ЭлектроннаяТранспортнаяНакладная")
			ИЛИ ТипЗнч(СтрокаНабора.СсылкаНаОбъект) = Тип("ДокументСсылка.ЭлектронныйЗаказНаряд")
			ИЛИ ТипЗнч(СтрокаНабора.СсылкаНаОбъект) = Тип("ДокументСсылка.ЭлектроннаяСопроводительнаяВедомость"))
			И ДокументыВНаборе.Найти(СтрокаНабора.СсылкаНаОбъект) = Неопределено Тогда
			ДокументыВНаборе.Добавить(СтрокаНабора.СсылкаНаОбъект); 
		КонецЕсли;
	КонецЦикла;
	
	Для Каждого СтрокаНабора Из ЭтотОбъект Цикл  
		Если (ТипЗнч(СтрокаНабора.СсылкаНаОбъект) = Тип("ДокументСсылка.ЭлектроннаяТранспортнаяНакладная")
			ИЛИ ТипЗнч(СтрокаНабора.СсылкаНаОбъект) = Тип("ДокументСсылка.ЭлектронныйЗаказНаряд")
			ИЛИ ТипЗнч(СтрокаНабора.СсылкаНаОбъект) = Тип("ДокументСсылка.ЭлектроннаяСопроводительнаяВедомость"))
			И ДокументыВНаборе.Найти(СтрокаНабора.СсылкаНаОбъект) = Неопределено Тогда
			ДокументыВНаборе.Добавить(СтрокаНабора.СсылкаНаОбъект);
		КонецЕсли;
	КонецЦикла;  
	
	ДополнительныеСвойства.Вставить("ДокументыВНаборе",    ДокументыВНаборе);
	// {/УАТ}

КонецПроцедуры

// {УАТ}
Процедура ПриЗаписи(Отказ, Замещение)
	
	Если ОбменДанными.Загрузка Тогда
		Возврат; 
	КонецЕсли;
	
	Запрос = Новый Запрос();
	Запрос.УстановитьПараметр("МассивЭПД", ДополнительныеСвойства.ДокументыВНаборе);

	Запрос.Текст = "ВЫБРАТЬ РАЗРЕШЕННЫЕ РАЗЛИЧНЫЕ
	               |	уатСвязанныеДокументыЭПД.ЗаказНаТС КАК СвязанныйДокумент,
	               |	уатСвязанныеДокументыЭПД.ЭПД КАК ЭПД,
	               |	СостоянияПоОбъектамУчетаЭДО.СостояниеЭДО КАК ПредставлениеСостояния,
	               |	ЕСТЬNULL(СостоянияПоОбъектамУчетаЭДО.ПредставлениеСостояния, """") КАК СостояниеЭДО
	               |ИЗ
	               |	РегистрСведений.уатСвязанныеДокументыЭПД КАК уатСвязанныеДокументыЭПД
	               |		ЛЕВОЕ СОЕДИНЕНИЕ РегистрСведений.СостоянияПоОбъектамУчетаЭДО КАК СостоянияПоОбъектамУчетаЭДО
	               |		ПО уатСвязанныеДокументыЭПД.ЭПД = СостоянияПоОбъектамУчетаЭДО.СсылкаНаОбъект
	               |			И (уатСвязанныеДокументыЭПД.ЭПД В (&МассивЭПД))
	               |ГДЕ
	               |	уатСвязанныеДокументыЭПД.ЭПД В(&МассивЭПД)";	
	Попытка
		
		Основания = Запрос.Выполнить().Выгрузить();
		
		Для Каждого ЭПД Из ДополнительныеСвойства.ДокументыВНаборе Цикл
			
				
			ОтборЭД = Новый Структура("ЭПД", ЭПД);
			ОснованияЭД = Основания.НайтиСтроки(ОтборЭД);
			
			Для Каждого ТекСтрока Из ОснованияЭД Цикл
				
				Если НЕ ЗначениеЗаполнено(ТекСтрока.СвязанныйДокумент) Тогда
					Продолжить;
				КонецЕсли;
				
				НаборЗаписей = РегистрыСведений.уатТекущееСостояниеЭДО.СоздатьНаборЗаписей();
				НаборЗаписей.Отбор.ДокументПеревозки.Установить(ТекСтрока.СвязанныйДокумент); 
				НаборЗаписей.Прочитать(); 
				
				Если НаборЗаписей.Количество() > 0 Тогда 
					Запись = НаборЗаписей[0];
					Если НЕ ЗначениеЗаполнено(Запись.СостояниеЭДО)
						И НЕ ЗначениеЗаполнено(Запись.ПредставлениеЭПД)
						И ТекСтрока.ПредставлениеСостояния = "" Тогда
						НаборЗаписей.Удалить(Запись);
						Продолжить;
					КонецЕсли;
				Иначе
					Запись = НаборЗаписей.Добавить();
					Запись.ДокументПеревозки = ТекСтрока.СвязанныйДокумент;
					Если ТекСтрока.ПредставлениеСостояния = "" Тогда
						Продолжить;
					КонецЕсли;
				КонецЕсли;
				Запись.СостояниеЭДО           = ТекСтрока.СостояниеЭДО;
				Запись.ПредставлениеСостояния = ТекСтрока.ПредставлениеСостояния;
				Запись.ЭПД                    = ЭПД;
				НаборЗаписей.Записать();
			КонецЦикла;
		КонецЦикла;
	Исключение
		Информация = ИнформацияОбОшибке();
	КонецПопытки;
	
КонецПроцедуры
// {/УАТ}

#КонецОбласти

#Иначе
	
	ВызватьИсключение НСтр("ru = 'Недопустимый вызов объекта на клиенте.'");
	
#КонецЕсли
