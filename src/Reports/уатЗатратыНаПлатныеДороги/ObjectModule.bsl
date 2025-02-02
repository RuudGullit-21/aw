
#Область ОбработчикиСобытий

Процедура ПриКомпоновкеРезультата(ДокументРезультат, ДанныеРасшифровки, СтандартнаяОбработка)
	
	Настройки = КомпоновщикНастроек.ПолучитьНастройки();
	ТипОтчета = Настройки.ПараметрыДанных.Элементы.Найти("ТипОтчета").Значение;
	Если ТипОтчета = 0 Тогда
			
		СхемаКомпоновкиДанных.НаборыДанных.НаборДанных1.Запрос = "ВЫБРАТЬ РАЗРЕШЕННЫЕ
		                                                         |	уатОтчетСистемыПлатонРасходы.ТС КАК ТС,
		                                                         |	уатОтчетСистемыПлатонРасходы.ПутьПройденныйТС КАК ПутьПройденныйТС,
		                                                         |	уатОтчетСистемыПлатонРасходы.СписаниеСРЗ КАК СписаниеСРЗ,
		                                                         |	уатОтчетСистемыПлатонРасходы.Ссылка.Организация КАК Организация,
		                                                         |	ЗНАЧЕНИЕ(Справочник.Сотрудники.ПустаяСсылка) КАК Водитель,
		                                                         |	ВЫБОР
		                                                         |		КОГДА уатОтчетСистемыПлатонРасходы.ПутьПройденныйТС = 0
		                                                         |			ТОГДА 0
		                                                         |		ИНАЧЕ уатОтчетСистемыПлатонРасходы.СписаниеСРЗ / уатОтчетСистемыПлатонРасходы.ПутьПройденныйТС
		                                                         |	КОНЕЦ КАК РубКм,
		                                                         |	ЗНАЧЕНИЕ(Справочник.уатВнешниеСистемы.Платон) КАК НаименованиеСистемы,
		                                                         |	ЗНАЧЕНИЕ(Документ.уатПутевойЛист.ПустаяСсылка) КАК ПутевойЛист
		                                                         |ИЗ
		                                                         |	Документ.уатОтчетСистемыПлатон.Расходы КАК уатОтчетСистемыПлатонРасходы
		                                                         |ГДЕ
		                                                         |	НЕ уатОтчетСистемыПлатонРасходы.Ссылка.ПометкаУдаления
		                                                         |	И уатОтчетСистемыПлатонРасходы.ДатаВремяНачалаДвижения >= &НачалоПериода
		                                                         |	И уатОтчетСистемыПлатонРасходы.ДатаВремяОкончанияДвижения <= &КонецПериода
		                                                         |
		                                                         |ОБЪЕДИНИТЬ ВСЕ
		                                                         |
		                                                         |ВЫБРАТЬ
		                                                         |	уатОтчетСистемыАвтодорРасходы.ТС,
		                                                         |	NULL,
		                                                         |	уатОтчетСистемыАвтодорРасходы.Сумма,
		                                                         |	уатОтчетСистемыАвтодорРасходы.Ссылка.Организация,
		                                                         |	ЗНАЧЕНИЕ(Справочник.Сотрудники.ПустаяСсылка),
		                                                         |	NULL,
		                                                         |	ЗНАЧЕНИЕ(Справочник.уатВнешниеСистемы.Автодор),
		                                                         |	ЗНАЧЕНИЕ(Документ.уатПутевойЛист.ПустаяСсылка)
		                                                         |ИЗ
		                                                         |	Документ.уатОтчетСистемыАвтодор.Расходы КАК уатОтчетСистемыАвтодорРасходы
		                                                         |ГДЕ
		                                                         |	НЕ уатОтчетСистемыАвтодорРасходы.Ссылка.ПометкаУдаления
		                                                         |	И уатОтчетСистемыАвтодорРасходы.ДатаОперации МЕЖДУ &НачалоПериода И &КонецПериода";
	Иначе
		СхемаКомпоновкиДанных.НаборыДанных.НаборДанных1.Запрос = "ВЫБРАТЬ
		                                                         |	МИНИМУМ(ВЫБОР
		                                                         |			КОГДА уатПутевойЛист.ДатаВыезда ЕСТЬ NULL
		                                                         |				ТОГДА ЕСТЬNULL(уатПутевойЛист1.ДатаВыезда, ДАТАВРЕМЯ(1, 1, 1))
		                                                         |			ИНАЧЕ ЕСТЬNULL(уатПутевойЛист.ДатаВыезда, ДАТАВРЕМЯ(1, 1, 1))
		                                                         |		КОНЕЦ) КАК ДатаВыезда,
		                                                         |	уатОтчетСистемыАвтодорРасходы.НомерСтроки КАК НомерСтроки,
		                                                         |	уатОтчетСистемыАвтодорРасходы.Ссылка КАК Ссылка
		                                                         |ПОМЕСТИТЬ втДатаВыездаАвтодор
		                                                         |ИЗ
		                                                         |	Документ.уатОтчетСистемыАвтодор.Расходы КАК уатОтчетСистемыАвтодорРасходы
		                                                         |		ЛЕВОЕ СОЕДИНЕНИЕ Документ.уатПутевойЛист КАК уатПутевойЛист
		                                                         |		ПО уатОтчетСистемыАвтодорРасходы.ТС = уатПутевойЛист.ТранспортноеСредство
		                                                         |			И (уатОтчетСистемыАвтодорРасходы.ДатаОперации МЕЖДУ уатПутевойЛист.ДатаВыезда И уатПутевойЛист.ДатаВозвращения)
		                                                         |			И (уатПутевойЛист.Проведен)
		                                                         |			И (НЕ уатПутевойЛист.ПометкаУдаления)
		                                                         |		ЛЕВОЕ СОЕДИНЕНИЕ Документ.уатПутевойЛист КАК уатПутевойЛист1
		                                                         |		ПО уатОтчетСистемыАвтодорРасходы.ТС = уатПутевойЛист1.ТранспортноеСредство
		                                                         |			И (уатОтчетСистемыАвтодорРасходы.ДатаОперации МЕЖДУ уатПутевойЛист1.ДатаВыезда И уатПутевойЛист1.ДатаВозвращения)
		                                                         |			И (уатПутевойЛист1.Проведен)
		                                                         |			И (НЕ уатПутевойЛист1.ПометкаУдаления)
		                                                         |
		                                                         |СГРУППИРОВАТЬ ПО
		                                                         |	уатОтчетСистемыАвтодорРасходы.НомерСтроки,
		                                                         |	уатОтчетСистемыАвтодорРасходы.Ссылка
		                                                         |;
		                                                         |
		                                                         |////////////////////////////////////////////////////////////////////////////////
		                                                         |ВЫБРАТЬ
		                                                         |	МИНИМУМ(ВЫБОР
		                                                         |			КОГДА уатПутевойЛист.ДатаВыезда ЕСТЬ NULL
		                                                         |				ТОГДА ЕСТЬNULL(уатПутевойЛист1.ДатаВыезда, ДАТАВРЕМЯ(1, 1, 1))
		                                                         |			ИНАЧЕ ЕСТЬNULL(уатПутевойЛист.ДатаВыезда, ДАТАВРЕМЯ(1, 1, 1))
		                                                         |		КОНЕЦ) КАК ДатаВыезда,
		                                                         |	уатОтчетСистемыПлатонРасходы.НомерСтроки КАК НомерСтроки,
		                                                         |	уатОтчетСистемыПлатонРасходы.Ссылка КАК Ссылка
		                                                         |ПОМЕСТИТЬ втдатаВыезда
		                                                         |ИЗ
		                                                         |	Документ.уатОтчетСистемыПлатон.Расходы КАК уатОтчетСистемыПлатонРасходы
		                                                         |		ЛЕВОЕ СОЕДИНЕНИЕ Документ.уатПутевойЛист КАК уатПутевойЛист
		                                                         |		ПО уатОтчетСистемыПлатонРасходы.ДатаВремяНачалаДвижения >= уатПутевойЛист.ДатаВыезда
		                                                         |			И уатОтчетСистемыПлатонРасходы.ДатаВремяНачалаДвижения <= уатПутевойЛист.ДатаВозвращения
		                                                         |			И уатОтчетСистемыПлатонРасходы.ТС = уатПутевойЛист.ТранспортноеСредство
		                                                         |			И (НЕ уатПутевойЛист.ПометкаУдаления)
		                                                         |			И (уатПутевойЛист.Проведен)
		                                                         |		ЛЕВОЕ СОЕДИНЕНИЕ Документ.уатПутевойЛист КАК уатПутевойЛист1
		                                                         |		ПО уатОтчетСистемыПлатонРасходы.ДатаВремяОкончанияДвижения >= уатПутевойЛист1.ДатаВыезда
		                                                         |			И уатОтчетСистемыПлатонРасходы.ДатаВремяОкончанияДвижения <= уатПутевойЛист1.ДатаВозвращения
		                                                         |			И уатОтчетСистемыПлатонРасходы.ТС = уатПутевойЛист1.ТранспортноеСредство
		                                                         |			И (НЕ уатПутевойЛист1.ПометкаУдаления)
		                                                         |			И (уатПутевойЛист1.Проведен)
		                                                         |
		                                                         |СГРУППИРОВАТЬ ПО
		                                                         |	уатОтчетСистемыПлатонРасходы.НомерСтроки,
		                                                         |	уатОтчетСистемыПлатонРасходы.Ссылка
		                                                         |;
		                                                         |
		                                                         |////////////////////////////////////////////////////////////////////////////////
		                                                         |ВЫБРАТЬ
		                                                         |	уатОтчетСистемыПлатонРасходы.ТС КАК ТС,
		                                                         |	уатОтчетСистемыПлатонРасходы.ПутьПройденныйТС КАК ПутьПройденныйТС,
		                                                         |	уатОтчетСистемыПлатонРасходы.СписаниеСРЗ КАК СписаниеСРЗ,
		                                                         |	уатОтчетСистемыПлатонРасходы.Ссылка.Организация КАК Организация,
		                                                         |	ВЫБОР
		                                                         |		КОГДА уатПутевойЛист.Водитель1 ЕСТЬ NULL
		                                                         |			ТОГДА ЕСТЬNULL(уатПутевойЛист1.Водитель1, ЗНАЧЕНИЕ(Справочник.Сотрудники.ПустаяСсылка))
		                                                         |		ИНАЧЕ ЕСТЬNULL(уатПутевойЛист.Водитель1, ЗНАЧЕНИЕ(Справочник.Сотрудники.ПустаяСсылка))
		                                                         |	КОНЕЦ КАК Водитель,
		                                                         |	уатОтчетСистемыПлатонРасходы.СписаниеСРЗ / уатОтчетСистемыПлатонРасходы.ПутьПройденныйТС КАК РубКм,
		                                                         |	ВЫБОР
		                                                         |		КОГДА уатПутевойЛист.ДатаВыезда ЕСТЬ NULL
		                                                         |			ТОГДА ЕСТЬNULL(уатПутевойЛист1.ДатаВыезда, ДАТАВРЕМЯ(1, 1, 1))
		                                                         |		ИНАЧЕ ЕСТЬNULL(уатПутевойЛист.ДатаВыезда, ДАТАВРЕМЯ(1, 1, 1))
		                                                         |	КОНЕЦ КАК ДатаВыезда,
		                                                         |	уатОтчетСистемыПлатонРасходы.Ссылка КАК Ссылка,
		                                                         |	уатОтчетСистемыПлатонРасходы.НомерСтроки КАК НомерСтроки,
		                                                         |	ВЫБОР
		                                                         |		КОГДА уатПутевойЛист.ДатаВыезда ЕСТЬ NULL
		                                                         |			ТОГДА ЕСТЬNULL(уатПутевойЛист1.Ссылка, ЗНАЧЕНИЕ(Документ.уатПутевойЛист.ПустаяСсылка))
		                                                         |		ИНАЧЕ ЕСТЬNULL(уатПутевойЛист.Ссылка, ЗНАЧЕНИЕ(Документ.уатПутевойЛист.ПустаяСсылка))
		                                                         |	КОНЕЦ КАК ПутевойЛист,
		                                                         |	ЗНАЧЕНИЕ(Справочник.уатВнешниеСистемы.Платон) КАК НаименованиеСистемы
		                                                         |ПОМЕСТИТЬ втВодители
		                                                         |ИЗ
		                                                         |	Документ.уатОтчетСистемыПлатон.Расходы КАК уатОтчетСистемыПлатонРасходы
		                                                         |		ЛЕВОЕ СОЕДИНЕНИЕ Документ.уатПутевойЛист КАК уатПутевойЛист
		                                                         |		ПО уатОтчетСистемыПлатонРасходы.ДатаВремяНачалаДвижения >= уатПутевойЛист.ДатаВыезда
		                                                         |			И уатОтчетСистемыПлатонРасходы.ДатаВремяНачалаДвижения <= уатПутевойЛист.ДатаВозвращения
		                                                         |			И уатОтчетСистемыПлатонРасходы.ТС = уатПутевойЛист.ТранспортноеСредство
		                                                         |			И (НЕ уатПутевойЛист.ПометкаУдаления)
		                                                         |			И (уатПутевойЛист.Проведен)
		                                                         |		ЛЕВОЕ СОЕДИНЕНИЕ Документ.уатПутевойЛист КАК уатПутевойЛист1
		                                                         |		ПО уатОтчетСистемыПлатонРасходы.ДатаВремяОкончанияДвижения >= уатПутевойЛист1.ДатаВыезда
		                                                         |			И уатОтчетСистемыПлатонРасходы.ДатаВремяОкончанияДвижения <= уатПутевойЛист1.ДатаВозвращения
		                                                         |			И уатОтчетСистемыПлатонРасходы.ТС = уатПутевойЛист1.ТранспортноеСредство
		                                                         |			И (НЕ уатПутевойЛист1.ПометкаУдаления)
		                                                         |			И (уатПутевойЛист1.Проведен)
		                                                         |
		                                                         |ОБЪЕДИНИТЬ ВСЕ
		                                                         |
		                                                         |ВЫБРАТЬ
		                                                         |	уатОтчетСистемыАвтодорРасходы.ТС,
		                                                         |	NULL,
		                                                         |	уатОтчетСистемыАвтодорРасходы.Сумма,
		                                                         |	уатОтчетСистемыАвтодорРасходы.Ссылка.Организация,
		                                                         |	ВЫБОР
		                                                         |		КОГДА уатПутевойЛист.Водитель1 ЕСТЬ NULL
		                                                         |			ТОГДА ЕСТЬNULL(уатПутевойЛист1.Водитель1, ЗНАЧЕНИЕ(Справочник.Сотрудники.ПустаяСсылка))
		                                                         |		ИНАЧЕ ЕСТЬNULL(уатПутевойЛист.Водитель1, ЗНАЧЕНИЕ(Справочник.Сотрудники.ПустаяСсылка))
		                                                         |	КОНЕЦ,
		                                                         |	NULL,
		                                                         |	ВЫБОР
		                                                         |		КОГДА уатПутевойЛист.ДатаВыезда ЕСТЬ NULL
		                                                         |			ТОГДА ЕСТЬNULL(уатПутевойЛист1.ДатаВыезда, ДАТАВРЕМЯ(1, 1, 1))
		                                                         |		ИНАЧЕ ЕСТЬNULL(уатПутевойЛист.ДатаВыезда, ДАТАВРЕМЯ(1, 1, 1))
		                                                         |	КОНЕЦ,
		                                                         |	уатОтчетСистемыАвтодорРасходы.Ссылка,
		                                                         |	уатОтчетСистемыАвтодорРасходы.НомерСтроки,
		                                                         |	ВЫБОР
		                                                         |		КОГДА уатПутевойЛист.ДатаВыезда ЕСТЬ NULL
		                                                         |			ТОГДА ЕСТЬNULL(уатПутевойЛист1.Ссылка, ЗНАЧЕНИЕ(Документ.уатПутевойЛист.ПустаяСсылка))
		                                                         |		ИНАЧЕ ЕСТЬNULL(уатПутевойЛист.Ссылка, ЗНАЧЕНИЕ(Документ.уатПутевойЛист.ПустаяСсылка))
		                                                         |	КОНЕЦ,
		                                                         |	ЗНАЧЕНИЕ(Справочник.уатВнешниеСистемы.Автодор)
		                                                         |ИЗ
		                                                         |	Документ.уатОтчетСистемыАвтодор.Расходы КАК уатОтчетСистемыАвтодорРасходы
		                                                         |		ЛЕВОЕ СОЕДИНЕНИЕ Документ.уатПутевойЛист КАК уатПутевойЛист
		                                                         |		ПО уатОтчетСистемыАвтодорРасходы.ТС = уатПутевойЛист.ТранспортноеСредство
		                                                         |			И (уатОтчетСистемыАвтодорРасходы.ДатаОперации МЕЖДУ уатПутевойЛист.ДатаВыезда И уатПутевойЛист.ДатаВозвращения)
		                                                         |			И (уатПутевойЛист.Проведен)
		                                                         |			И (НЕ уатПутевойЛист.ПометкаУдаления)
		                                                         |		ЛЕВОЕ СОЕДИНЕНИЕ Документ.уатПутевойЛист КАК уатПутевойЛист1
		                                                         |		ПО уатОтчетСистемыАвтодорРасходы.ТС = уатПутевойЛист1.ТранспортноеСредство
		                                                         |			И (уатОтчетСистемыАвтодорРасходы.ДатаОперации МЕЖДУ уатПутевойЛист1.ДатаВыезда И уатПутевойЛист1.ДатаВозвращения)
		                                                         |			И (уатПутевойЛист1.Проведен)
		                                                         |;
		                                                         |
		                                                         |////////////////////////////////////////////////////////////////////////////////
		                                                         |ВЫБРАТЬ
		                                                         |	втВодители.ТС КАК ТС,
		                                                         |	втВодители.ПутьПройденныйТС КАК ПутьПройденныйТС,
		                                                         |	втВодители.СписаниеСРЗ КАК СписаниеСРЗ,
		                                                         |	втВодители.Организация КАК Организация,
		                                                         |	МАКСИМУМ(втВодители.Водитель) КАК Водитель,
		                                                         |	втВодители.РубКм КАК РубКм,
		                                                         |	втВодители.ПутевойЛист КАК ПутевойЛист,
		                                                         |	втВодители.НаименованиеСистемы КАК НаименованиеСистемы
		                                                         |ИЗ
		                                                         |	втВодители КАК втВодители
		                                                         |		ВНУТРЕННЕЕ СОЕДИНЕНИЕ втдатаВыезда КАК втдатаВыезда
		                                                         |		ПО втВодители.Ссылка = втдатаВыезда.Ссылка
		                                                         |			И втВодители.НомерСтроки = втдатаВыезда.НомерСтроки
		                                                         |
		                                                         |СГРУППИРОВАТЬ ПО
		                                                         |	втВодители.ТС,
		                                                         |	втВодители.ПутьПройденныйТС,
		                                                         |	втВодители.СписаниеСРЗ,
		                                                         |	втВодители.Организация,
		                                                         |	втВодители.РубКм,
		                                                         |	втВодители.ПутевойЛист,
		                                                         |	втВодители.НаименованиеСистемы
		                                                         |
		                                                         |ОБЪЕДИНИТЬ ВСЕ
		                                                         |
		                                                         |ВЫБРАТЬ
		                                                         |	втВодители.ТС,
		                                                         |	втВодители.ПутьПройденныйТС,
		                                                         |	втВодители.СписаниеСРЗ,
		                                                         |	втВодители.Организация,
		                                                         |	втВодители.Водитель,
		                                                         |	втВодители.РубКм,
		                                                         |	втВодители.ПутевойЛист,
		                                                         |	втВодители.НаименованиеСистемы
		                                                         |ИЗ
		                                                         |	втВодители КАК втВодители
		                                                         |		ВНУТРЕННЕЕ СОЕДИНЕНИЕ втДатаВыездаАвтодор КАК втДатаВыездаАвтодор
		                                                         |		ПО втВодители.Ссылка = втДатаВыездаАвтодор.Ссылка
		                                                         |			И втВодители.НомерСтроки = втДатаВыездаАвтодор.НомерСтроки";
	Конецесли;
	
КонецПроцедуры

#КонецОбласти
